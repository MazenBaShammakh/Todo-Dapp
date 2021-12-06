import 'package:dapp_todo_list/screens/auth/widgets/private_key_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/ethaddress_model.dart';
import './widgets/eth_data_card.dart';
import './widgets/confirm_account_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _keyController;

  @override
  void initState() {
    _keyController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ethAddress = Provider.of<EthAddress>(context);
    const sizedBox = SizedBox(height: kDefaultSpacing * 4);

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
          padding: EdgeInsets.only(
            right: kDefaultSpacing * 4,
            left: kDefaultSpacing * 4,
            top: kDefaultSpacing * 6 + MediaQuery.of(context).viewPadding.top,
          ),
          width: double.infinity,
          height: double.infinity,
          decoration: decorationBodyContainer(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                title(),
                sizedBox,
                PrivateKeyInput(keyController: _keyController),
                sizedBox,
                EthDataCard(
                  ethAddress: ethAddress,
                  sizedBox: sizedBox,
                ),
                sizedBox,
                ConfirmAccountButton(ethAddress: ethAddress),
              ],
            ),
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
      image: DecorationImage(
        image: Image.asset('assets/images/bg-mobile-light.jpg').image,
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
      ),
    );
  }

  SizedBox title() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'account'.toUpperCase(),
        textAlign: TextAlign.left,
        style: GoogleFonts.josefinSans(
          color: kLightThemeLightGrayishBlue,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: kDefaultSpacing,
        ),
      ),
    );
  }
}
