import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/pages/main/homePage.dart';
import 'package:medicine/pages/main/pharmacyMapPage.dart';
import 'package:medicine/pages/main/reminderPage.dart';
import 'package:medicine/pages/main/userPage.dart';
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
      child: Positioned(
          bottom: 0,
          right: 0,
          left: 0,
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                                builder: (context) => HomePage(),
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
                                  builder: (context) => PharmacyMapPage()));
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      child: IconButton(
                        iconSize: 50,
                        tooltip: "Alarm",
                        icon: IconFont(
                            color: AppColors.MAIN_COLOR,
                            size: 0.045,
                            iconName: IConFontHelper.CLOCK),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReminderPage()));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPage()));
                        },
                      ),
                    ),
                  ),
                ]),
          )),
    );
  }
}
