import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import './todo_model.dart';

class TodoList extends ChangeNotifier {
  List<Todo> todosList = [];
  bool isLoading = true;
  int todosCounter = 0;
  int filter = 0;

  void updateFilter(int newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  final String _rpcUrl = "http://192.168.1.48:7545";
  final String _wsUrl = "ws://192.168.1.48:7545/";
  late Web3Client client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late DeployedContract contract;
  late ContractFunction todosCount;
  late ContractFunction todos;
  late ContractFunction newTodo;
  late ContractFunction toggleIsCompleted;
  late ContractFunction deleteTodo;
  late ContractEvent addedTodoEvent;

  TodoList(EthereumAddress? sender) {
    // create web3 client
    initWeb3Client();
    // get contract's ABI
    initAbi(sender);
  }

  void initWeb3Client() {
    client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );
  }

  Future<void> initAbi(EthereumAddress? sender) async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
      jsonAbi["networks"]["5777"]["address"],
    );

    // get deployed contract after getting abi
    initDeployedContract(sender);
  }

  Future<void> initDeployedContract(EthereumAddress? sender) async {
    contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "TodoList"),
      _contractAddress,
    );

    // get contract functions & events after getting contract
    initContractFuncsEvents(sender);
  }

  Future<void> initContractFuncsEvents(EthereumAddress? sender) async {
    todos = contract.function("todos");
    todosCount = contract.function("todosCount");
    newTodo = contract.function("newTodo");
    toggleIsCompleted = contract.function("toggleIsCompleted");
    deleteTodo = contract.function("deleteTodo");
    addedTodoEvent = contract.event("AddedTodo");

    getTodos(sender);
  }

  // contract calls
  Future<void> getTodos(EthereumAddress? sender) async {
    List<dynamic> todosCountList = await client.call(
      sender: sender,
      contract: contract,
      function: todosCount,
      params: [sender],
    );

    BigInt todosCountBI = todosCountList[0];
    todosCounter = todosCountBI.toInt();

    todosList.clear();
    for (var i = 0; i < todosCounter; i++) {
      var todo = await client.call(
        sender: sender,
        contract: contract,
        function: todos,
        params: [sender, BigInt.from(i)],
      );

      if (todo[0] == BigInt.from(-1)) continue;

      BigInt idBI = todo[0];
      int id = idBI.toInt();
      String title = todo[1];
      bool isCompleted = todo[2];

      todosList.add(
        Todo(
          id: id,
          title: title,
          isCompleted: isCompleted,
        ),
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(
    Credentials? cred,
    EthereumAddress? sender,
    String title,
  ) async {
    isLoading = true;
    notifyListeners();

    await client.sendTransaction(
      cred!,
      Transaction.callContract(
        from: sender,
        contract: contract,
        function: newTodo,
        parameters: [sender, title],
      ),
    );

    getTodos(sender);
  }

  Future<void> toggleIsCompletedFunc(
    Credentials? cred,
    EthereumAddress? sender,
    BigInt id,
  ) async {
    await client.sendTransaction(
      cred!,
      Transaction.callContract(
        from: sender,
        contract: contract,
        function: toggleIsCompleted,
        parameters: [sender, id],
      ),
    );
  }

  Future<void> deleteTodoFunc(
    Credentials? cred,
    EthereumAddress? sender,
    BigInt id,
  ) async {
    isLoading = true;
    notifyListeners();

    await client.sendTransaction(
      cred!,
      Transaction.callContract(
        from: sender,
        contract: contract,
        function: deleteTodo,
        parameters: [sender, id],
      ),
    );

    getTodos(sender);
  }
}
