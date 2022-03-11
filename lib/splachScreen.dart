import 'package:flutter/material.dart';
import 'package:medicine/helpers/appInfo.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SplachScreen extends StatelessWidget {
  int duration;
  Widget goTopage;
  Future<dynamic> function;

  SplachScreen(
      {this.duration = 0, required this.goTopage, required this.function});

  @override
  Widget build(BuildContext context) {
    // if (Database.isPharmacist == false) {
    //   Future.delayed(Duration(seconds: this.duration), () {
    //     //Fetch pharmacy data from the cloud before starting the app
    //     qs.getPharmaciesFromFirestore().then((value) => Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => this.goTopage)));
    //   });
    // } else {
    Future.delayed(Duration(seconds: this.duration), () {
      //Fetch pharmacy data from the cloud before starting the app
      // Navigator.pop(context);
      function.then((value) => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => this.goTopage)));
    });

    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
      body: Container(
        color: AppInfo.MAIN_COLOR,
        alignment: Alignment.center,
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: IconFont(
              color: Colors.white,
              iconName: IConFontHelper.LOGO,
              size: 0.15,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: height * 0.22,
              width: width * 0.22,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.5)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
