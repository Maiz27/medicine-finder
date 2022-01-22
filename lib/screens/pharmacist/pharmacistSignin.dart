import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

class PharmacistSignin extends StatefulWidget {
  const PharmacistSignin({Key? key}) : super(key: key);

  @override
  State<PharmacistSignin> createState() => _PharmacistSigninState();
}

class _PharmacistSigninState extends State<PharmacistSignin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHiddenPW = true;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
      // To remove 'Bottom Overflowed by....' error
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.black,
        width: width,
        height: height,
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
            child: SingleChildScrollView(
              reverse: true,
              child: Column(children: [
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
                // SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.05,
                    bottom: height * 0.04,
                  ),
                  child: Text(
                    "Sign in to your Pharmcist Account ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
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

                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.04,
                  ),
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
                      suffixIcon: IconButton(
                        icon: isHiddenPW
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isHiddenPW = !isHiddenPW;
                          });
                        },
                      ),
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

                // Button section
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.04,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await authService.signInWithEmailAndPassword(
                          emailController.text, passwordController.text);

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
                    //add padding to provide space between text
                    //and button borders
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.03),
                      child: Text(
                        'SIGN IN',
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
            ),
          ),
        ]),
      ),
    );
  }
}
