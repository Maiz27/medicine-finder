import 'package:flutter/material.dart';
import 'package:medicine/pages/main/WelcomePage.dart';
import 'package:medicine/pages/main/homePage.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:provider/provider.dart';
import '../models/userModel.dart';

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
            return user == null ? WelcomePage() : HomePage();
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
