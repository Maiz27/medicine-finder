import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine/helpers/utility.dart';
import 'package:medicine/models/pharmacyModel.dart';

import 'package:medicine/models/userModel.dart';
import 'package:medicine/services/database.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final rootRef = FirebaseFirestore.instance;

  late CurrUser _currUser;

  late Pharmacy _pharmacy;

  Utility userType = new Utility();

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

        userType.setUserType(1);
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
          accType: 'Email',
          imgURL: null,
        );
        userType.setUserType(1);
        Database.createUser(_currUser);
        Database.setCurrUser(_currUser);
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
        imgURL: result.user!.photoURL,
      );
      userType.setUserType(1);
      Database.createUser(_currUser);
      Database.setCurrUser(_currUser);
    } else {
      // Retrieve user info for old users
      userType.setUserType(1);
      Database.getUserDoc(result.user!.uid);
    }
  }

  Future createPharmacy(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required double lat,
      required double lng}) async {
    var credential;
    Timestamp now = Timestamp.now();
    if (email == '' || password == '' || phone == '' || lat == 0 || lng == 0) {
      Fluttertoast.showToast(msg: 'Please fill out the entire form!');
    } else {
      try {
        credential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        _pharmacy = Pharmacy(
          id: credential.user.uid,
          email: email,
          name: name,
          lat: lat,
          lng: lng,
          tele: phone,
          dateCreated: now,
        );
        userType.setUserType(2);
        Database.createPharmacyDoc(pharmacy: _pharmacy);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
      return _user(credential.user);
    }
  }

  Future<void> signOut() async {
    userType.setUserType(0);
    return await _firebaseAuth.signOut();
  }
}
