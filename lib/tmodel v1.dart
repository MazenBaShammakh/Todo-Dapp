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

class Todo {
  final int id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
  });
}

class TodoList extends ChangeNotifier {
  List<Todo> _todos = [];
  bool isLoading = true;
  int taskCount = 0;

  late Web3 web3;
  TodoList() {
    web3 = Web3();
  }

  Future<void> checkConnection() async {
    final netId = await web3.client.getNetworkId();
    print(netId);
  }

  // contract calls
  getTodos() async {
    List<dynamic> totalTasksList = await web3.client
        .call(contract: web3.contract, function: web3.todosCount, params: []);
    BigInt totalTasks = totalTasksList[0];
    taskCount = totalTasks.toInt();
    print(totalTasks);

    _todos.clear();
    for (var i = 0; i < totalTasks.toInt(); i++) {
      var temp = await web3.client.call(
          contract: web3.contract,
          function: web3.todos,
          params: [BigInt.from(i)]);
      _todos.add(Todo(id: temp[0], title: temp[1], isCompleted: temp[2]));
    }

    isLoading = false;
    notifyListeners();
  }

  addTodo(String title) async {
    isLoading = true;
    notifyListeners();
    await web3.client.sendTransaction(
        web3.cred,
        Transaction.callContract(
            contract: web3.contract,
            function: web3.newTodo,
            parameters: [title]));

    getTodos();
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
