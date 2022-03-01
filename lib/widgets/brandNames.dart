import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/appInfo.dart';
import '../helpers/deviceDimensions.dart';
import '../helpers/iconHelper.dart';
import 'IconFont.dart';

class BrandNamesWidget extends StatelessWidget {
  BrandNamesWidget({Key? key, required this.brandName, required this.index})
      : super(key: key);
  final String brandName;
  final int index;

  final TextEditingController _brandNamesController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _brandNamesController.text = brandName;
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.04,
        left: width * 0.025,
        right: height * 0.025,
      ),
      child: TextField(
        controller: _brandNamesController,
        cursorColor: Colors.black,
        style: TextStyle(
          color: AppInfo.MAIN_COLOR,
          letterSpacing: 1.5,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          constraints: BoxConstraints(maxWidth: width * 0.45),
          labelText: 'Brand name: ' + index.toString(),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: height * 0.01,
              right: height * 0.01,
            ),
            child: IconFont(
              color: AppInfo.MAIN_COLOR,
              iconName: IConFontHelper.CAN,
              size: 0.045,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: height * 0.03,
            color: AppInfo.MAIN_COLOR,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
