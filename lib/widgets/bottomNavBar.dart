import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/screens/user/main/userHomeScreen.dart';
import 'package:medicine/screens/user/main/pharmacyMapScreen.dart';
import 'package:medicine/screens/user/main/searchHistoryScreen.dart';
import 'package:medicine/screens/user/main/userScreen.dart';

import 'package:medicine/services/database.dart';
import 'package:provider/provider.dart';

import 'IconFont.dart';

//double currentpage = 1;

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: height * 0.1,
        width: width,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.2),
            offset: Offset.zero,
          )
        ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ClipOval(
            child: Material(
              child: IconButton(
                iconSize: 50,
                tooltip: "Home",
                icon: IconFont(
                    color: AppColors.MAIN_COLOR,
                    size: 0.05,
                    iconName: IConFontHelper.LOGO),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserHomeScreen(),
                      ));
                },
              ),
            ),
          ),
          ClipOval(
            child: Material(
              child: IconButton(
                iconSize: 50,
                tooltip: "Map",
                icon: IconFont(
                    color: AppColors.MAIN_COLOR,
                    size: 0.045,
                    iconName: IConFontHelper.PHARM_lOC),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacyMapScreen()));
                },
              ),
            ),
          ),
          ClipOval(
            child: Material(
              child: IconButton(
                iconSize: 50,
                tooltip: "Search History",
                icon: IconFont(
                    color: AppColors.MAIN_COLOR,
                    size: 0.045,
                    iconName: IConFontHelper.HISTORY),
                onPressed: () async {
                  await Database().getUserHistory().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchHistoryScreen()));
                  });
                },
              ),
            ),
          ),
          ClipOval(
            child: Material(
              child: IconButton(
                iconSize: 50,
                tooltip: "Profile",
                icon: IconFont(
                    color: AppColors.MAIN_COLOR,
                    size: 0.045,
                    iconName: IConFontHelper.USER),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserScreen()));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
