import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../common/pangea_logo_svg.dart';

class PangeaLogoAndNameWidget extends StatelessWidget {
  const PangeaLogoAndNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 120,
            child: const PangeaLogoSvg(width: 120, forceColor: Colors.white),
          ),
          //PTODO - widget to display app name with consistent style
          Text(
            AppConfig.applicationName,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          // const Text(
          //   "Life is Learning",
          //   style: TextStyle(
          //     fontSize: 18,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
