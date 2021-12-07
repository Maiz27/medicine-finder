import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine/models/userModel.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _user(auth.User? user) {
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_user);
  }

  // Signin function with email & passowrd
  Future<User?>? signInWithEmailAndPassword(
      String email, String password) async {
    var credential;
    if (email == '' && password == '') {
      Fluttertoast.showToast(msg: 'Email & Passord can\'t be empty!');
    } else {
      try {
        credential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    return _user(credential.user);
  }

  // Signup function with email & passowrd
  Future<User?>? creatUserWithEmailAndPAssword(
      String email, String password) async {
    var credential;
    if (email == '' && password == '') {
      Fluttertoast.showToast(msg: 'Email & Passord can\'t be empty!');
    } else {
      try {
        credential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    return _user(credential.user);
  }

  // Google SignIn
  Future<User?>? signInWithGoogle() async {
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

    //Once Signed in, return the User Credentail
    auth.UserCredential user =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
