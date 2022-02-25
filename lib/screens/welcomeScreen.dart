import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                // logo with oval shape around it
                //Wrap clipoval in a center widget to prevent it from streching
                Center(
                  child: ClipOval(
                    child: Container(
                      width: width * 0.2,
                      height: height * 0.2,
                      color: AppColors.MAIN_COLOR,
                      alignment: Alignment.center,

                      // use self created 'IconFont class' to get icon from specified font
                      child: IconFont(
                        color: Colors.white,
                        iconName: IConFontHelper.LOGO,
                        size: 0.14,
                      ),
                    ),
                  ),
                ),
                // use SizedBox to fake spacing and give roon for the desgin elements

                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.03,
                    bottom: height * 0.03,
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
                    top: height * 0.04,
                    bottom: height * 0.04,
                  ),
                  child: Text(
                    'Finding your desired medication,\nhas never been easier!\nOne click away!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.ACCENT,
                      fontSize: height * 0.02,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),

                //Button Section
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/Userwelcome');
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
                    padding: EdgeInsets.all(width * 0.025),
                    child: Text(
                      'User',
                      style: TextStyle(
                        color: AppColors.ACCENT,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.03,
                    bottom: height * 0.03,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(
                          context, '/PharmacistWelcome');
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
                      padding: EdgeInsets.all(width * 0.025),
                      child: Text(
                        'Pharmacist',
                        style: TextStyle(
                          color: AppColors.ACCENT,
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
