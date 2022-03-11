import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/appInfo.dart';
import '../helpers/deviceDimensions.dart';
import '../helpers/iconHelper.dart';
import '../helpers/wrapper.dart';
import '../models/pharmacyModel.dart';
import '../screens/pharmacist/main/medicineListScreen.dart';
import '../screens/pharmacist/main/popularMedicinesScreen.dart';
import '../screens/user/main/userHomeScreen.dart';
import '../services/authService.dart';
import '../services/database.dart';
import 'IconFont.dart';

class PharmacyDrawer extends StatelessWidget {
  const PharmacyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);
    final authService = Provider.of<AuthService>(context);

    Pharmacy? _pharmacy = Database.getCurrPharmacy();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: width * 0.05),
        child: Column(children: [
          IconFont(
            color: AppInfo.MAIN_COLOR,
            iconName: IConFontHelper.LOGO,
            size: 0.1,
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.015),
            child: Text(
              AppInfo.NAME,
              style: TextStyle(
                color: AppInfo.MAIN_COLOR,
                fontSize: width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: height * 0.015, bottom: height * 0.015),
            child: Text(
              _pharmacy!.name,
              style: TextStyle(
                color: AppInfo.MAIN_COLOR,
                fontSize: width * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: AppInfo.ACCENT,
            thickness: 2,
            indent: height * 0.01,
            endIndent: height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.only(top: width * 0.01),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MedicineListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: AppInfo.MAIN_COLOR,
                onPrimary: AppInfo.ACCENT,
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.07, right: width * 0.07),
                child: Text(
                  'Medicine List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: AppInfo.ACCENT,
            thickness: 2,
            indent: height * 0.01,
            endIndent: height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.only(top: width * 0.01),
            child: ElevatedButton(
              onPressed: () async {
                await Database.getPopularMedicineCollection()
                    .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PopularMedicinesScreen()),
                        ));
              },
              style: ElevatedButton.styleFrom(
                primary: AppInfo.MAIN_COLOR,
                onPrimary: AppInfo.ACCENT,
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                child: Text(
                  'Popular Medicine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: AppInfo.ACCENT,
            thickness: 2,
            indent: height * 0.01,
            endIndent: height * 0.01,
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: width * 0.01),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => PharmacyInfoScreen()),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       primary: AppInfo.MAIN_COLOR,
          //       onPrimary: AppInfo.ACCENT,
          //     ),
          //     child: Padding(
          //       padding:
          //           EdgeInsets.only(left: width * 0.06, right: width * 0.06),
          //       child: Text(
          //         'Pharmacy Info',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: width * 0.02,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   color: AppInfo.ACCENT,
          //   thickness: 2,
          //   indent: height * 0.01,
          //   endIndent: height * 0.01,
          // ),
          Padding(
            padding: EdgeInsets.only(top: width * 0.01),
            child: ElevatedButton(
              onPressed: () {
                Database.isPharmacist = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserHomeScreen()),
                    (Route<dynamic> route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                primary: AppInfo.MAIN_COLOR,
                onPrimary: AppInfo.ACCENT,
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                child: Text(
                  'Search for Medicine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: AppInfo.ACCENT,
            thickness: 2,
            indent: height * 0.01,
            endIndent: height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.only(top: width * 0.01),
            child: ElevatedButton(
              onPressed: () async {
                await authService.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Wrapper()),
                    (Route<dynamic> route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                primary: AppInfo.MAIN_COLOR,
                onPrimary: AppInfo.ACCENT,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
