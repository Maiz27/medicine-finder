import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullnameController = TextEditingController();

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
                        'Sign Up New User!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: fullnameController,
                          cursorColor: AppColors.ACCENT,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(
                              Icons.person,
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
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            await authService.creatUserWithEmailAndPAssword(
                                emailController.text,
                                passwordController.text,
                                "Maged Faiz");
                            Navigator.pushReplacementNamed(context, '/wrapper');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            onPrimary: AppColors.MAIN_COLOR,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 5, color: AppColors.MAIN_COLOR),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.5)),
                            ),
                          ),
                          //add padding to provide space between text
                          //and button borders
                          child: Padding(
                            padding: EdgeInsets.all(height * 0.03),
                            child: Text(
                              'SIGN UP',
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

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.MAIN_COLOR,
                            onPrimary: AppColors.ACCENT,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.5)),
                            ),
                          ),
                          //add padding to provide space between text
                          //and button borders
                          child: Padding(
                            padding: EdgeInsets.all(height * 0.03),
                            child: Text(
                              'Already have an account,\nSign In here!',
                              textAlign: TextAlign.center,
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
                    ]),
              )
            ])));
  }
}
