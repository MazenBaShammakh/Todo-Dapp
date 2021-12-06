import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/ethaddress_model.dart';

class PrivateKeyInput extends StatefulWidget {
  const PrivateKeyInput({
    Key? key,
    required this.keyController,
  }) : super(key: key);

  final TextEditingController keyController;

  @override
  _PrivateKeyInputState createState() => _PrivateKeyInputState();
}

class _PrivateKeyInputState extends State<PrivateKeyInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultSpacing),
        color: kLightThemeVeryLightGrayishBlue,
      ),
      child: Row(
        children: [
          const SizedBox(width: kDefaultSpacing),
          Expanded(
            child: TextField(
              controller: widget.keyController,
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
              String? pk = validatePK(widget.keyController.text);
              if (pk != null) {
                final ethAddress = Provider.of<EthAddress>(
                  context,
                  listen: false,
                );
                ethAddress.setPrivateKey = pk;
                await ethAddress.initCred();
                widget.keyController.clear();
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }

                setState(() {
                  // _ethAddress = ethAddress.ethAddress;
                  // _generatedEthAddress = true;
                });
              }
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
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
}
