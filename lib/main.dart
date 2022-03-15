import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/screens/user/main/pharmacyMapScreen.dart';
import 'package:medicine/screens/welcomeScreen.dart';
import 'package:medicine/screens/user/registrations/emailRegistrationScreen.dart';
import 'package:medicine/screens/user/registrations/phoneRegistrationScreen.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/helpers/wrapper.dart';
import 'package:medicine/services/database.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/screens/splachScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firbase before the app startsx
  await Firebase.initializeApp();
  // To hide Status bar, set setEnabledSystemUIMode to immersive
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  Dimension(window.devicePixelRatio.toDouble());
  runApp(
      //Use MultiPovider as the parent for the app to make the authentication
      //service work on all its childern(pages)
      MultiProvider(
          //add the list of providers used in ur app here for them to be built
          //on app launch instead of on different app pages
          providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<QueryService>(
          create: (_) => QueryService(),
        ),
        Provider<Dimension>(
          create: (_) => Dimension(window.devicePixelRatio.toDouble()),
        ),
        Provider<Database>(
          create: (_) => Database(),
        ),
      ],
          child: MaterialApp(
            //remove debug indicator in the app
            debugShowCheckedModeBanner: false,
            //To use custom text Fonts, call them in the material app using them
            theme: ThemeData(fontFamily: 'Roboto'),
            title: 'Medicine Finder',

            //Definig the apps inital route and other routes for easier
            //call of pages
            initialRoute: '/',
            routes: {
              //'/': (context) => Wrapper(),
              '/wrapper': (context) => Wrapper(),
              '/Userwelcome': (context) => WelcomeScreen(),
              '/EmailRegister': (context) => EmailRegistration(),
              '/PhoneRegister': (context) => PhoneRegistrationScreen(),
              '/map': (context) => PharmacyMapScreen(),
            },

            //use slef created Splashpage as the first page that appears
            //when starting the app

            // home: PharmacistSignup(),
            home: SplachScreen(
              duration: 2,
              goTopage: Wrapper(),
              function: QueryService().getPharmaciesFromFirestore(),
            ),
          )));
}
