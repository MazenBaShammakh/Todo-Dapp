import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../todos/todos_screen.dart';
import '../../../models/ethaddress_model.dart';

class ConfirmAccountButton extends StatelessWidget {
  const ConfirmAccountButton({
    Key? key,
    required this.ethAddress,
  }) : super(key: key);

  final EthAddress ethAddress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: ethAddress.ethAddress == null
            ? null
            : () {
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
          'Confirm account',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
