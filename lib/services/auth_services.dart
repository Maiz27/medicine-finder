import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine/helpers/utility.dart';
import 'package:medicine/models/userModel.dart';
import 'package:medicine/services/database.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final rootRef = FirebaseFirestore.instance;
  String verifID = "";

  late CurrUser _currUser;

  CurrUser getCurrUserInfo() {
    return _currUser;
  }

  auth.User? _user(auth.User? user) {
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return null;
    }
    return user;
  }

  Stream<auth.User?>? get user {
    return _firebaseAuth.authStateChanges().map(_user);
  }

  // Signin function with email & passowrd
  Future<auth.User?>? signInWithEmailAndPassword(
      String email, String password) async {
    var credential;

    if (email == '' && password == '') {
      Fluttertoast.showToast(msg: 'Email & Passord can\'t be empty!');
    } else {
      try {
        credential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        Database.getUserDoc(credential.user!.uid);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    return _user(credential.user);
  }

  // Signup function with email & passowrd
  Future<auth.User?>? creatUserWithEmailAndPAssword(
      String email, String password, String fullName) async {
    var credential;
    Timestamp now = Timestamp.now();
    if (email == '' && password == '') {
      Fluttertoast.showToast(msg: 'Email & Passord can\'t be empty!');
    } else {
      try {
        credential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        _currUser = CurrUser(
            email: credential.user.email,
            uid: credential.user.uid,
            dateCreated: now,
            fullName: '$fullName',
            accType: 'Email');

        Database.createUser(_currUser);
        Utility().setCurrUser(_currUser);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    return _user(credential.user);
  }

  // Google SignIn
  Future<auth.User?>? signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //Obtaining auth details from  the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //creat new credential
    final auth.OAuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Once Signed in, Create database doc for new user
    auth.UserCredential result =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);

    if (result.additionalUserInfo!.isNewUser) {
      Timestamp now = Timestamp.now();
      _currUser = CurrUser(
        email: result.user!.email,
        uid: result.user!.uid,
        dateCreated: now,
        fullName: result.user!.displayName.toString(),
        accType: 'Google',
        tele: result.user!.phoneNumber,
      );
      Database.createUser(_currUser);
      Utility().setCurrUser(_currUser);
    } else {
      // Retrieve user info for old users
      Database.getUserDoc(result.user!.uid);
    }
  }

  // Future<String> loginWithPhone(String name, String numb) async {
  //   _firebaseAuth.verifyPhoneNumber(
  //     phoneNumber: numb,
  //     verificationCompleted: (auth.PhoneAuthCredential credential) async {
  //       await _firebaseAuth.signInWithCredential(credential).then((result) {
  //         if (result.additionalUserInfo!.isNewUser) {
  //           _currUser = CurrUser(
  //             email: result.user!.email,
  //             uid: result.user!.uid,
  //             dateCreated: Timestamp.now(),
  //             fullName: name,
  //             accType: 'tele',
  //             tele: numb,
  //           );
  //           Database.createUser(_currUser);
  //         } else {
  //           Database.getUserDoc(result.user!.uid)
  //               .then((user) => {_currUser = CurrUser.fromJson(user)});
  //         }

  //         print("You are logged in successfully");
  //       });
  //     },
  //     verificationFailed: (auth.FirebaseAuthException e) {
  //       print(e.message);
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       verifID = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );

  //   return verifID;
  // }

  // void verifyOTP(String name, String numb, String smsCode) async {
  //   auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
  //       verificationId: verifID, smsCode: smsCode);

  //   await _firebaseAuth.signInWithCredential(credential).then((result) {
  //     if (result.additionalUserInfo!.isNewUser) {
  //       _currUser = CurrUser(
  //         email: result.user!.email,
  //         uid: result.user!.uid,
  //         dateCreated: Timestamp.now(),
  //         fullName: name,
  //         accType: 'tele',
  //         tele: numb,
  //       );
  //       Database.createUser(_currUser);
  //     } else {
  //       Database.getUserDoc(result.user!.uid)
  //           .then((user) => {_currUser = CurrUser.fromJson(user)});
  //     }
  //     print("You are logged in successfully");
  //     // Navigator.pushReplacementNamed(context, '/wrapper');
  //     Fluttertoast.showToast(
  //         msg: "You are logged in successfully",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   });
  // }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
