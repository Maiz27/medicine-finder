import 'package:flutter/material.dart';
import 'package:medicine/helpers/appInfo.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/deviceDimensions.dart';
import '../helpers/iconHelper.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppInfo.MAIN_COLOR,
        title: Text("About Us"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipOval(
              child: Container(
                width: width * 0.2,
                height: height * 0.2,
                color: AppInfo.MAIN_COLOR,
                alignment: Alignment.center,
                child: IconFont(
                    color: Colors.white,
                    size: 0.14,
                    iconName: IConFontHelper.LOGO),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
            ),
            child: Text(
              'Medicine Finder',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppInfo.MAIN_COLOR,
                  fontFamily: 'Roboto',
                  fontSize: height * 0.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
            ),
            child: Text(
              'Finding your desired medication,\nhas never been easier!\nOne click away!',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: AppInfo.MAIN_COLOR,
                fontSize: height * 0.02,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
              left: width * 0.04,
              right: width * 0.04,
            ),
            child: Text(
              'To become a pharmacist, Send a formal request containing your a screenshot of you User info and Pharmacy infomation to via this email:\n\n Magedfaiz98@gmail.com \n\nOr contact us!',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: AppInfo.MAIN_COLOR,
                fontSize: height * 0.02,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.03),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppInfo.MAIN_COLOR,
                  shadowColor: Colors.transparent,
                  onPrimary: AppInfo.MAIN_COLOR,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 5, color: AppInfo.MAIN_COLOR),
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.5)),
                  )),
              onPressed: () {
                launch("tel:+249910077844");
              },
              child: Padding(
                padding: EdgeInsets.all(height * 0.03),
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: AppInfo.ACCENT,
                    fontFamily: 'Roboto',
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: height * 0.03),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         primary: AppInfo.MAIN_COLOR,
          //         shadowColor: Colors.transparent,
          //         onPrimary: AppInfo.MAIN_COLOR,
          //         shape: RoundedRectangleBorder(
          //           side: BorderSide(width: 5, color: AppInfo.MAIN_COLOR),
          //           borderRadius:
          //               BorderRadius.all(Radius.circular(width * 0.5)),
          //         )),
          //     onPressed: () {},
          //     child: Padding(
          //       padding: EdgeInsets.all(height * 0.03),
          //       child: Text(
          //         'Become a Pharmacist',
          //         style: TextStyle(
          //           color: AppInfo.ACCENT,
          //           fontFamily: 'Roboto',
          //           fontSize: height * 0.02,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
