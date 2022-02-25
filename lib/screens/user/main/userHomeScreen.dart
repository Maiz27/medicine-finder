import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/screens/user/searchScreen.dart';
import 'package:medicine/widgets/searchCategories.dart';
import 'package:medicine/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);
    // final authService = Provider.of<AuthService>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please provide either the "Generic" or the "Brand" name of the medicine you are looking for!\n\nSearch for medicine by',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: height * 0.02,
                      color: AppColors.MAIN_COLOR,
                    ),
                  ),
                  SearchCategory('Generic Name', 'scientificName',
                      IConFontHelper.DR, SeacrhScreen('Generic name')),
                  SearchCategory('Brand Name', 'commonName',
                      IConFontHelper.LAB__BOTTLE, SeacrhScreen('Brand name')),
                  // Padding(
                  //   padding: const EdgeInsets.all(20),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       await authService.signOut();
                  //       // Navigator.of(context).pushNamedAndRemoveUntil(
                  //       //     '/wrapper', (Route<dynamic> route) => false);
                  //       Navigator.pushReplacementNamed(context, '/wrapper');
                  //     },
                  //     child: Text(
                  //       'Log out',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       primary: AppColors.MAIN_COLOR,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            CustomBottomBar()
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types

