import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

// First page after splash, shows the login & register options and redirects accordingly
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //Override the initial State of the widget to ask user for their location
  //permission from the welcome page
  @override
  void initState() {
    //call the getlocation function
    _getLocationPermission();
    //then resume the already defined state for Welcome using 'super' keyword
    super.initState();
  }

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
            Center(
              child: Column(
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
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Medicine Finder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.ACCENT,
                        fontFamily: 'Roboto',
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  //Another sixed box
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Finding your desired medication,\nhas never been easier!\nOne click away!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.ACCENT,
                      fontSize: height * 0.02,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  //Button Section
                  ////Google Signin button
                  Row(
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
                              size: 0.05,
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
                              Navigator.pushNamed(context, '/login');
                            },
                            iconSize: 50,
                            icon: IconFont(
                                color: AppColors.MAIN_COLOR,
                                size: 0.06,
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

                  SizedBox(
                    height: 50,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
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
                          side:
                              BorderSide(width: 5, color: AppColors.MAIN_COLOR),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Enable location permissions function
void _getLocationPermission() async {
  var location = new Location();
  try {
    location.requestPermission(); //to lunch location permission popup

  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      print('Permission denied');
    }
  }
}
