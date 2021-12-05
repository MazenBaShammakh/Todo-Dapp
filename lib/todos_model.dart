import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Todo extends ChangeNotifier {
  final int id;
  final String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
  });
}

class EthAddress extends ChangeNotifier {
  String _privateKey = "";
  late Credentials cred;
  late EthereumAddress _ownAddress;

  Future<void> initCred() async {
    cred = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await cred.extractAddress();
  }
}

class TodoList extends ChangeNotifier {
  List<Todo> todosList = [];
  bool isLoading = true;
  int todosCounter = 0;
  int filter = 0;

  void updateFilter(int newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  // RPC server & web socket URLs
  final String _rpcUrl = "http://192.168.1.48:7545";
  final String _wsUrl = "ws://192.168.1.48:7545/";
  // hard-coded private key
  final String _privateKey =
      "3dc404dc2d3490042f7887455e2bcd12e75e62b3472d5e7fd365e4e5118f98f6";
  late Web3Client client;
  late Credentials cred;
  late EthereumAddress _ownAddress;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late DeployedContract contract;
  late ContractFunction todosCount;
  late ContractFunction todos;
  late ContractFunction newTodo;
  late ContractFunction toggleIsCompleted;
  late ContractFunction deleteTodo;
  late ContractEvent addedTodoEvent;

  TodoList() {
    // create web3 client
    initWeb3Client();
    // get credentials
    initCred();
    // get contract's ABI
    initAbi();
  }

  void initWeb3Client() {
    client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );
  }

  Future<void> initCred() async {
    cred = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await cred.extractAddress();
  }

  Future<void> initAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
      jsonAbi["networks"]["5777"]["address"],
    );
    // print(_contractAddress);

    // get deployed contract after getting abi
    initDeployedContract();
  }

  Future<void> initDeployedContract() async {
    // print(_abiCode);
    contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "TodoList"),
      _contractAddress,
    );
    // print(contract.address);

    // get contract functions & events after getting contract
    initContractFuncsEvents();
  }

  Future<void> initContractFuncsEvents() async {
    todos = contract.function("todos");
    todosCount = contract.function("todosCount");
    newTodo = contract.function("newTodo");
    toggleIsCompleted = contract.function("toggleIsCompleted");
    deleteTodo = contract.function("deleteTodo");
    addedTodoEvent = contract.event("AddedTodo");

    getTodos();
  }

  // Future<void> checkConnection() async {
  //   final netId = await client.getNetworkId();
  //   print(netId);
  // }

  // contract calls
  Future<void> getTodos() async {
    List<dynamic> todosCountList =
        await client.call(contract: contract, function: todosCount, params: []);
    BigInt todosCountBI = todosCountList[0];
    todosCounter = todosCountBI.toInt();
    // print(todosCountI);

    todosList.clear();
    for (var i = 0; i < todosCounter; i++) {
      var todo = await client
          .call(contract: contract, function: todos, params: [BigInt.from(i)]);
      // print(todo.runtimeType);
      // print(todo[0].runtimeType);
      // print(todo[1].runtimeType);
      // print(todo[2].runtimeType);
      // print(todo);
      // print(todo[0]);
      if (todo[0] == BigInt.from(-1)) continue;
      BigInt idBI = todo[0];
      int id = idBI.toInt();
      String title = todo[1];
      bool isCompleted = todo[2];
      todosList.add(Todo(id: id, title: title, isCompleted: isCompleted));
    }
    // print('fetching todos');
    // print(todosList[0].title);
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    isLoading = true;
    notifyListeners();
    await client.sendTransaction(
        cred,
        Transaction.callContract(
            contract: contract, function: newTodo, parameters: [title]));

    getTodos();
  }

  Future<void> toggleIsCompletedFunc(BigInt id) async {
    await client.sendTransaction(
      cred,
      Transaction.callContract(
          contract: contract, function: toggleIsCompleted, parameters: [id]),
    );
  }

  Future<void> deleteTodoFunc(BigInt id) async {
    await client.sendTransaction(
      cred,
      Transaction.callContract(
          contract: contract, function: deleteTodo, parameters: [id]),
    );
  }
}

class Web3 {
  // RPC server & web socket URLs
  final String _rpcUrl = "http://192.168.1.48:7545";
  final String _wsUrl = "ws://192.168.1.48:7545/";
  // hard-coded private key
  final String _privateKey =
      "3dc404dc2d3490042f7887455e2bcd12e75e62b3472d5e7fd365e4e5118f98f6";
  late Web3Client client;
  late Credentials cred;
  late EthereumAddress _ownAddress;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late DeployedContract contract;
  late ContractFunction todosCount;
  late ContractFunction todos;
  late ContractFunction newTodo;
  late ContractEvent addedTodoEvent;
  Web3() {
    // create web3 client
    initWeb3Client();
    // get credentials
    initCred();
    // get contract's ABI
    initAbi();
  }

  void initWeb3Client() {
    client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );
  }

  Future<void> initCred() async {
    cred = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await cred.extractAddress();
  }

  // //
  Future<void> initAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
      jsonAbi["networks"]["5777"]["address"],
    );
    print(_contractAddress);

    // get deployed contract after getting abi
    initDeployedContract();
  }

  Future<void> initDeployedContract() async {
    // print(_abiCode);
    contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "TodoList"),
      _contractAddress,
    );
    print(contract.address);

    // get contract functions & events after getting contract
    initContractFuncsEvents();
  }

  Future<void> initContractFuncsEvents() async {
    todos = contract.function("todos");
    todosCount = contract.function("todosCount");
    newTodo = contract.function("newTodo");
    addedTodoEvent = contract.event("AddedTodo");
  }
}
