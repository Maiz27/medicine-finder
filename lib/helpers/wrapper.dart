import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine/screens/user/main/homeScreen.dart';
import 'package:medicine/screens/welcomeScreen.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  // void initState() {
  //   _getLocationPermission();
  // }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            if (authService.userType.getUserType() == 1) {
              // For handling user related queries before the app starts
              Database.getUserDoc(user!.uid);
              Database.setUserSubCollectionRef(user.uid);
              Database().getUserHistory();
              return HomeScreen();
            } else if (authService.userType.getUserType() == 2) {
              // For handling pharmacist related queries before the app starts
              Database.getPharmacyDoc(user!.uid);
              Database.setPharmacySubCollectionRef(user.uid);
              Database().getPharmacyMedicine();
              return HomeScreen();
            } else {
              return WelcomeScreen();
            }

            // return user == null ? WelcomePage() : HomePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

// void _getLocationPermission() async {
//   var location = new Location();
//   try {
//     await location.requestPermission(); //to lunch location permission popup
//   } on PlatformException catch (e) {
//     if (e.code == 'PERMISSION_DENIED') {
//       print('Permission denied');
//     }
//   }
// }
