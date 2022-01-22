import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

// First page after splash, shows the login & register options and redirects accordingly
class UserWelcomeScreen extends StatelessWidget {
  const UserWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Colors.black,

        // use Stack Widget to overlay widgets over eachother
        // with the first item in the stack being the backgroud
        child: Stack(
          children: [
            Positioned.fill(
                // use opacity to dim image
                child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/imgs/bg.jpg',
                // fit image across its allowed space
                fit: BoxFit.cover,
              ),
            )),
            Column(
              // align childern from the center
              mainAxisAlignment: MainAxisAlignment.center,
              //stech children across the y-axis
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // logo with oval shape around it
                //Wrap clipoval in a center widget to prevent it from streching
                Center(
                  child: ClipOval(
                    child: Container(
                      width: width * 0.22,
                      height: height * 0.22,
                      color: AppColors.MAIN_COLOR,
                      alignment: Alignment.center,

                      // use self created 'IconFont class' to get icon from specified font
                      child: IconFont(
                        color: Colors.white,
                        iconName: IConFontHelper.LOGO,
                        size: 0.15,
                      ),
                    ),
                  ),
                ),
                // use SizedBox to fake spacing and give roon for the desgin elements

                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.05,
                  ),
                  child: Text(
                    'Medicine Finder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.ACCENT,
                        fontFamily: 'Roboto',
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //Another sixed box

                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.05,
                  ),
                  child: Text(
                    'Sign in to your Account as a User\nto find your desired medicine',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: AppColors.ACCENT,
                      fontSize: height * 0.02,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),

                //Button Section
                ////Google Signin button
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await authService.signInWithGoogle();
                              Navigator.pushReplacementNamed(
                                  context, '/wrapper');
                            },
                            iconSize: 50,
                            icon: IconFont(
                              color: AppColors.MAIN_COLOR,
                              iconName: IConFontHelper.GOOGLE,
                              size: 0.04,
                            ),
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: AppColors.ACCENT,
                            ),
                          ),
                        ],
                      ),
                      //Sign in with email button
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, '/EmailRegister');
                            },
                            iconSize: 50,
                            icon: IconFont(
                                color: AppColors.MAIN_COLOR,
                                size: 0.05,
                                iconName: IConFontHelper.EMAIL),
                          ),
                          Text(
                            'Sign in with Email',
                            style: TextStyle(
                              color: AppColors.ACCENT,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.05,
                    left: width * 0.03,
                    right: width * 0.03,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/PhoneRegister');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      onPrimary: AppColors.MAIN_COLOR,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 5, color: AppColors.MAIN_COLOR),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.5)),
                      ),
                    ),
                    //add padding to provide space between text
                    //and button borders
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.03),
                      child: Text(
                        'Sign in with mobile number',
                        style: TextStyle(
                          color: AppColors.ACCENT,
                          fontFamily: 'Roboto',
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
