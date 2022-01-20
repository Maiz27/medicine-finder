import 'package:flutter/material.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);
    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Container(
      width: width * 0.3,
      height: height * 0.17,
      margin: EdgeInsets.all(30),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset.zero,
            )
          ]),
      child: Text(
        this.message,
        softWrap: true,
        style: TextStyle(
          fontSize: height * 0.02,
          letterSpacing: width * 0.0005,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
