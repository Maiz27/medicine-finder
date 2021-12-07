import 'package:flutter/material.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class IconFont extends StatelessWidget {
  Color color;
  double size;
  String iconName;

  IconFont({required this.color, required this.size, required this.iconName});

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();

    return Text(
      this.iconName,
      style: TextStyle(
        color: this.color,
        fontSize: height * this.size,
        fontFamily: 'Medicine',
      ),
    );
  }
}
