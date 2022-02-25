import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/models/userModel.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/services/database.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);
    //final utility = Provider.of<Database>(context);
    CurrUser? _user = Database.getCurrUser();
    bool googleAcc = _user!.isGoogleAcc();
    bool emailAcc = _user.isEmailAcc();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/imgs/bg2.jpg',
                // fit image across its allowed space
                fit: BoxFit.cover,
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  googleAcc
                      ? Center(
                          child: ClipOval(
                            child: Image.network(
                              _user.imgURL.toString(),
                            ),
                          ),
                        )
                      : Center(
                          child: ClipOval(
                            child: IconFont(
                              color: AppColors.ACCENT,
                              iconName: IConFontHelper.USER,
                              size: 0.1,
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.05, bottom: height * 0.05),
                    child: Container(
                      // width: width * 0.8,
                      // height: height * 0.4,
                      decoration: BoxDecoration(
                          color: AppColors.ACCENT.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset.zero,
                            )
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: height * 0.02,
                              bottom: height * 0.02,
                            ),
                            child: Text(
                              _user.fullName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.025,
                                fontWeight: FontWeight.bold,
                                letterSpacing: width * 0.005,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: height * 0.02,
                              bottom: height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Account Type: ',
                                  style: TextStyle(
                                    color: AppColors.MAIN_COLOR,
                                    fontSize: width * 0.025,
                                    letterSpacing: width * 0.000005,
                                  ),
                                ),
                                Text(
                                  _user.accType,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.025,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: width * 0.001,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: height * 0.02,
                              bottom: height * 0.02,
                            ),
                            child: googleAcc || emailAcc
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Email: ',
                                        style: TextStyle(
                                          color: AppColors.MAIN_COLOR,
                                          fontSize: width * 0.025,
                                          letterSpacing: width * 0.000005,
                                        ),
                                      ),
                                      Text(
                                        _user.email.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.025,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: width * 0.001,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Telephone: ',
                                        style: TextStyle(
                                          color: AppColors.MAIN_COLOR,
                                          fontSize: width * 0.025,
                                          letterSpacing: width * 0.000005,
                                        ),
                                      ),
                                      Text(
                                        _user.tele.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.025,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: width * 0.005,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: height * 0.02,
                              bottom: height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Created on: ',
                                  style: TextStyle(
                                    color: AppColors.MAIN_COLOR,
                                    fontSize: width * 0.025,
                                    letterSpacing: width * 0.000005,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd()
                                      .format(_user.dateCreated.toDate()),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.025,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: width * 0.005,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () async {
                        await authService.signOut();
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     '/wrapper', (Route<dynamic> route) => false);
                        Navigator.pushReplacementNamed(context, '/wrapper');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.MAIN_COLOR,
                        onPrimary: AppColors.ACCENT,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.5)),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(height * 0.014),
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
            CustomBottomBar(),
          ],
        ),
      ),
    );
  }
}
