import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/helpers/utility.dart';
import 'package:medicine/models/userModel.dart';
import 'package:medicine/services/database.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

CurrUser? currUser;
String verificationID = "";

class PhoneSignInPage extends StatefulWidget {
  const PhoneSignInPage({Key? key}) : super(key: key);

  @override
  _PhoneSignInPageState createState() => _PhoneSignInPageState();

  CurrUser? getCurrUserInfo() {
    return currUser;
  }
}

class _PhoneSignInPageState extends State<PhoneSignInPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController phoneNumController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  bool otpVisibility = false;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
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
                    height: 40,
                  ),
                  Text(
                    'Sign In To Your Account!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.ACCENT,
                        fontFamily: 'Roboto',
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
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
                      controller: phoneNumController,
                      cursorColor: AppColors.ACCENT,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: AppColors.ACCENT,
                        letterSpacing: 1.5,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(
                          Icons.phone_android,
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
                  Visibility(
                    child: TextField(
                      controller: otpController,
                      cursorColor: AppColors.ACCENT,
                      decoration: InputDecoration(
                        labelText: 'OTP Code',
                        prefixIcon: Icon(
                          Icons.sms,
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
                      keyboardType: TextInputType.number,
                    ),
                    visible: otpVisibility,
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
                        if (otpVisibility) {
                          verifyOTP();
                        } else {
                          loginWithPhone();
                        }
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
                          otpVisibility ? "Verify" : "Login",
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
        ]),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((result) {
          if (result.additionalUserInfo!.isNewUser) {
            currUser = CurrUser(
              email: result.user!.email,
              uid: result.user!.uid,
              dateCreated: Timestamp.now(),
              fullName: fullnameController.text,
              accType: 'tele',
              tele: phoneNumController.text,
            );
            Database.createUser(currUser!);
          } else {
            Database.getUserDoc(result.user!.uid)
                .then((user) => {currUser = CurrUser.fromJson(user)});
          }

          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((result) {
      if (result.additionalUserInfo!.isNewUser) {
        currUser = CurrUser(
          email: result.user!.email,
          uid: result.user!.uid,
          dateCreated: Timestamp.now(),
          fullName: fullnameController.text,
          accType: 'tele',
          tele: phoneNumController.text,
        );
        Database.createUser(currUser!);
      } else {
        Database.getUserDoc(result.user!.uid)
            .then((user) => {currUser = CurrUser.fromJson(user)});
      }
      print("You are logged in successfully");
      Utility().setCurrUser(currUser!);

      Navigator.pushNamed(context, '/wrapper');
      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
