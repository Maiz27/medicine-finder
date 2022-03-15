import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/appInfo.dart';
import '../helpers/deviceDimensions.dart';
import '../helpers/iconHelper.dart';
import '../screens/pharmacist/editMedicineScreen.dart';
import 'IconFont.dart';

// ignore: must_be_immutable
class BrandNamesWidget extends StatefulWidget {
  BrandNamesWidget({
    Key? key,
    required this.brandName,
    required this.index,
    required this.nameController,
    required this.priceController,
    required this.inStock,
  }) : super(key: key);
  final Map brandName;
  final int index;
  final TextEditingController nameController;
  final TextEditingController priceController;
  bool inStock;

  @override
  State<BrandNamesWidget> createState() => _BrandNamesWidgetState();
}

class _BrandNamesWidgetState extends State<BrandNamesWidget> {
  bool get inStock => widget.inStock;
  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);
    widget.nameController.text = widget.brandName['name'];
    widget.priceController.text = widget.brandName['price'].toString();
    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.03,
        left: width * 0.025,
        right: height * 0.025,
      ),
      child: Column(
        children: [
          Text(
            'Brand name: ' + (widget.index + 1).toString(),
            style: TextStyle(
              fontSize: height * 0.02,
              color: AppInfo.MAIN_COLOR,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
              bottom: height * 0.02,
            ),
            child: TextField(
              controller: widget.nameController,
              cursorColor: Colors.black,
              style: TextStyle(
                color: AppInfo.MAIN_COLOR,
                letterSpacing: 1.5,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                constraints: BoxConstraints(maxWidth: width * 0.45),
                labelText: 'name',
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
          ),
          TextField(
            controller: widget.priceController,
            cursorColor: Colors.black,
            style: TextStyle(
              color: AppInfo.MAIN_COLOR,
              letterSpacing: 1.5,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              constraints: BoxConstraints(maxWidth: width * 0.45),
              labelText: 'price',
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: height * 0.01,
                  right: height * 0.01,
                  top: height * 0.005,
                ),
                child: IconFont(
                  color: AppInfo.MAIN_COLOR,
                  iconName: IConFontHelper.CASH,
                  size: 0.043,
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
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "In-Stock:",
                  style: TextStyle(
                    fontSize: height * 0.03,
                    color: AppInfo.MAIN_COLOR,
                  ),
                ),
                Switch(
                    activeColor: AppInfo.MAIN_COLOR,
                    value: widget.inStock,
                    onChanged: (value) {
                      EditMedicineScreen.setinStock(widget.index, value);
                      setState(() {
                        widget.inStock = value;
                      });
                    }),
              ],
            ),
          ),
          Divider(
            color: AppInfo.ACCENT,
            thickness: 2,
            indent: height * 0.01,
            endIndent: height * 0.01,
          )
        ],
      ),
    );
  }
}
