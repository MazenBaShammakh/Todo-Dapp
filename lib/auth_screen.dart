import 'package:dapp_todo_list/todos_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import './constants.dart';
import './todos_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _keyController = TextEditingController();
  bool _generatedEthAddress = false;
  EthereumAddress? _ethAddress;

  @override
  Widget build(BuildContext context) {
    final ethAddress = Provider.of<EthAddress>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          padding: const EdgeInsets.only(
            right: kDefaultSpacing * 4,
            left: kDefaultSpacing * 4,
            // top: kDefaultSpacing * 6 + MediaQuery.of(context).viewPadding.top,
          ),
          width: double.infinity,
          height: double.infinity,
          decoration: decorationBodyContainer(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultSpacing),
                  color: kLightThemeVeryLightGrayishBlue,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: kDefaultSpacing),
                    Expanded(
                      child: TextField(
                        controller: _keyController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Paste your private key here',
                          hintStyle: GoogleFonts.josefinSans(
                            fontSize: 18,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                        style: GoogleFonts.josefinSans(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        String? pk = validatePK(_keyController.text);
                        if (pk != null) {
                          final ethAddress = Provider.of<EthAddress>(
                            context,
                            listen: false,
                          );
                          ethAddress.setPrivateKey = pk;
                          await ethAddress.initCred();
                          _keyController.clear();
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          setState(() {
                            _ethAddress = ethAddress.ethAddress;
                            _generatedEthAddress = true;
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kDefaultSpacing * 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kDefaultSpacing * 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultSpacing),
                  color: kLightThemeVeryLightGrayishBlue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EthAddressData(
                      isAddressGenerated: ethAddress.ethAddress == null,
                      title: 'Ethereum Address',
                      placeholder: '0xFF..',
                      data: ethAddress.ethAddress == null
                          ? ''
                          : '0x${ethAddress.ethAddress!.hex.substring(2).toUpperCase()}',
                    ),
                    const SizedBox(height: kDefaultSpacing * 4),
                    EthAddressData(
                      isAddressGenerated: ethAddress.ethAddress == null,
                      title: 'Ether Amount',
                      placeholder: '0.00 ETH',
                      data: ethAddress.ethAddress == null
                          ? ''
                          : '${ethAddress.getEthAmount} ETH',
                    ),
                    const SizedBox(height: kDefaultSpacing * 4),
                    EthAddressData(
                      isAddressGenerated: ethAddress.ethAddress == null,
                      title: 'Transaction Count',
                      placeholder: '0',
                      data: ethAddress.ethAddress == null
                          ? ''
                          : '${ethAddress.getTxCount}',
                    ),
                    const SizedBox(height: kDefaultSpacing * 4),
                    EthAddressData(
                      isAddressGenerated: ethAddress.ethAddress == null,
                      title: 'Gas Price (in WEI)',
                      placeholder: '0 WEI',
                      data: ethAddress.ethAddress == null
                          ? ''
                          : '${ethAddress.getGasPriceInWei} WEI',
                    ),
                    const SizedBox(height: kDefaultSpacing * 4),
                    EthAddressData(
                      isAddressGenerated: ethAddress.ethAddress == null,
                      title: 'Gas Price (in ETH)',
                      placeholder: '0 ETH',
                      data: ethAddress.ethAddress == null
                          ? ''
                          : '${ethAddress.getGasPriceInEth} ETH',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kDefaultSpacing * 4),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(TodosScreen.routeName);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: kDefaultSpacing * 2),
                    ),
                    elevation: MaterialStateProperty.all<double>(0.0),
                  ),
                  child: Text(
                    'Confirm address',
                    style: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePK(String pk) {
    // remove spaces, if any
    if (pk.contains(' ')) {
      pk.replaceAll(' ', '');
    }

    // after spaces removal, check the private key's length
    if (pk.length != 64) return null;

    List<String> hex = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ];
    // check for
    for (int i = 0; i < pk.length; i++) {
      if (hex.contains(pk[i])) continue;
      return null;
    }
    return pk;
  }

  BoxDecoration decorationBodyContainer() {
    return BoxDecoration(
      color: kLightThemeLightGrayishBlue,
      // image: DecorationImage(
      //   image: Image.asset('assets/images/bg-mobile-light.jpg').image,
      //   fit: BoxFit.contain,
      //   alignment: Alignment.topCenter,
      // ),
    );
  }
}

class EthAddressData extends StatelessWidget {
  const EthAddressData({
    Key? key,
    required this.isAddressGenerated,
    required this.title,
    required this.placeholder,
    required this.data,
  }) : super(key: key);

  final bool isAddressGenerated;
  final String title;
  final String placeholder;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: kDefaultSpacing),
        Text(
          isAddressGenerated ? placeholder : data!,
          textAlign: TextAlign.left,
          style: GoogleFonts.josefinSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
