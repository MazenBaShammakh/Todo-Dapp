import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:decimal/decimal.dart';

class EthAddress extends ChangeNotifier {
  String _privateKey = "";
  Credentials? cred;
  EthereumAddress? _ownAddress;
  EtherAmount? _etherAmt;
  int? _txCount;
  EtherAmount? _gasPrice;

  set setPrivateKey(String pk) => _privateKey = pk;

  EthereumAddress? get ethAddress => _ownAddress;

  String? get getEthAmount =>
      _etherAmt!.getValueInUnit(EtherUnit.ether).toString();

  int? get getTxCount => _txCount!;

  String? get getGasPriceInWei =>
      _gasPrice!.getValueInUnit(EtherUnit.wei).toString();

  String? get getGasPriceInEth =>
      Decimal.parse(_gasPrice!.getValueInUnit(EtherUnit.ether).toString())
          .toString();

  Future<void> initCred() async {
    cred = EthPrivateKey.fromHex(_privateKey);
    _ownAddress = await cred!.extractAddress();

    List<dynamic> _results = await _getEthData(_ownAddress);
    _etherAmt = _results[0] as EtherAmount;
    _txCount = _results[1] as int;
    _gasPrice = _results[2] as EtherAmount;
  }

  Future<List<dynamic>> _getEthData(EthereumAddress? sender) async {
    const String _rpcUrl = "http://192.168.1.48:7545";
    const String _wsUrl = "ws://192.168.1.48:7545/";
    Web3Client client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );

    EtherAmount etherAmt = await client.getBalance(sender!);

    int txCount = await client.getTransactionCount(sender);

    EtherAmount gasPrice = await client.getGasPrice();

    List<dynamic> result = [etherAmt, txCount, gasPrice];
    return result;
  }
}
