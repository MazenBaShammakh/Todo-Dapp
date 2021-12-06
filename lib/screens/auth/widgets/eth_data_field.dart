import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class EthDataField extends StatelessWidget {
  const EthDataField({
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
