import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine/screens/pharmacist/main/medicineListScreen.dart';
import 'package:medicine/screens/user/main/userHomeScreen.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/services/database.dart';
import 'package:provider/provider.dart';

import '../screens/welcomeScreen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            try {
              Database.getUserDoc(user!.uid);
              Database.setUserSubCollectionRef(user.uid);
              Database().getUserHistory();

              if (Database.isPharmacist == true) {
                return MedicineListScreen();
              } else {
                return UserHomeScreen();
              }
            } catch (e) {
              return WelcomeScreen();
            }
            //   if (authService.isUser() == true) {
            //     Utility.getUserData(user.uid);
            //     return UserHomeScreen();
            //   }
            //   if (authService.isPharmacy() == true) {
            //     Utility.getPharmacyData(user.uid);
            //     return PharmacyHomeScreen();
            //   }
            // }

            // return user == null ? WelcomeScreen() : UserHomeScreen();
            // } else {
            //   return Scaffold(
            //     body: Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //   );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
