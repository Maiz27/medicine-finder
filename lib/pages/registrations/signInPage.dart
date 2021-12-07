import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    bool isHiddenPW = true;
    return Scaffold(
        // To remove 'Bottom Overflowed by....' error
        resizeToAvoidBottomInset: false,
        body: Container(
            height: height,
            width: width,
            color: Colors.black,

            // use Stack Widget to overlay widgets over eachother
            // with the first item in the stack being the backgroud
            child: Stack(children: [
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
                    children: <Widget>[
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
                      SizedBox(height: 40),
                      Text(
                        'Sign In To Your Account!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: emailController,
                          cursorColor: AppColors.ACCENT,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.ACCENT,
                            ),
                            labelStyle: TextStyle(
                              fontSize: height * 0.02,
                              color: AppColors.ACCENT,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: passwordController,
                          cursorColor: AppColors.ACCENT,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.password,
                              color: AppColors.ACCENT,
                            ),
                            // suffixIcon: IconButton(
                            //   icon: isHiddenPW
                            //       ? Icon(Icons.visibility_off)
                            //       : Icon(Icons.visibility),
                            //   onPressed: () {
                            //     setState(() {
                            //       if (isHiddenPW == false) {
                            //         isHiddenPW = true;
                            //       } else {
                            //         isHiddenPW = false;
                            //       }
                            //     });
                            //   },
                            // ),
                            labelStyle: TextStyle(
                              fontSize: height * 0.02,
                              color: AppColors.ACCENT,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          obscureText: isHiddenPW,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      // Button section
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: FlatButton(
                          color: AppColors.MAIN_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          //add padding to provide space between text and button borders
                          padding: EdgeInsets.all(25),
                          onPressed: () async {
                            await authService.signInWithEmailAndPassword(
                                emailController.text, passwordController.text);
                            Navigator.pushReplacementNamed(context, '/wrapper');
                          },

                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),

                        // by defual, material widgets adds edges to any container
                        // to avoid that, use 'ClipRRect' to chop off the edges
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              //Provide the splash color, highlight color and the action when tapped
                              //Splash & Highligh
                              splashColor:
                                  AppColors.MAIN_COLOR.withOpacity(0.2),
                              highlightColor:
                                  AppColors.MAIN_COLOR.withOpacity(0.2),

                              // Use 'onTap' for onPressed Capabilities
                              onTap: () {
                                // ignore: unnecessary_statements
                                Navigator.pushReplacementNamed(
                                    context, '/EmailRegister');
                              },
                              //Wrapping section end

                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Register here',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.ACCENT,
                                    fontFamily: 'Roboto',
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // Use decoration to customize the container
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  //color transparent property to make the button look transparent with only the border showing
                                  color: Colors.transparent,
                                  // provide color for the border
                                  border: Border.all(
                                    //the color argument in boder takes const color values so use hexa-code
                                    color: AppColors.MAIN_COLOR,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              )
            ])));
  }
}
