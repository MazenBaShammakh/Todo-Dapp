import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/ethaddress_model.dart';
import './eth_data_field.dart';

class EthDataCard extends StatelessWidget {
  const EthDataCard({
    Key? key,
    required this.ethAddress,
    required this.sizedBox,
  }) : super(key: key);

  final EthAddress ethAddress;
  final SizedBox sizedBox;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          EthDataField(
            isAddressGenerated: ethAddress.ethAddress == null,
            title: 'Ethereum Address',
            placeholder: '0x..',
            data: ethAddress.ethAddress == null
                ? ''
                : '0x${ethAddress.ethAddress!.hex.substring(2).toUpperCase()}',
          ),
          sizedBox,
          EthDataField(
            isAddressGenerated: ethAddress.ethAddress == null,
            title: 'Ether Amount',
            placeholder: '0.00 ETH',
            data: ethAddress.ethAddress == null
                ? ''
                : '${ethAddress.getEthAmount} ETH',
          ),
          sizedBox,
          EthDataField(
            isAddressGenerated: ethAddress.ethAddress == null,
            title: 'Transaction Count',
            placeholder: '0',
            data:
                ethAddress.ethAddress == null ? '' : '${ethAddress.getTxCount}',
          ),
          sizedBox,
          EthDataField(
            isAddressGenerated: ethAddress.ethAddress == null,
            title: 'Gas Price (in WEI)',
            placeholder: '0 WEI',
            data: ethAddress.ethAddress == null
                ? ''
                : '${ethAddress.getGasPriceInWei} WEI',
          ),
          sizedBox,
          EthDataField(
            isAddressGenerated: ethAddress.ethAddress == null,
            title: 'Gas Price (in ETH)',
            placeholder: '0 ETH',
            data: ethAddress.ethAddress == null
                ? ''
                : '${ethAddress.getGasPriceInEth} ETH',
          ),
        ],
      ),
    );
  }
}
