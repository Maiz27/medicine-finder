import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/pages/main/pharmacyMapPage.dart';

import 'package:medicine/pages/registrations/phoneSignInPage.dart';
import 'package:medicine/pages/registrations/signInPage.dart';
import 'package:medicine/pages/splachPage.dart';
import 'package:medicine/pages/main/welcomePage.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:medicine/helpers/wrapper.dart';
import 'package:medicine/services/queryService.dart';
import 'package:provider/provider.dart';
import 'pages/registrations/signUpPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firbase before the app starts
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
              '/welcome': (context) => WelcomePage(),
              '/login': (context) => SignInPage(),
              '/EmailRegister': (context) => SignUpPage(),
              '/PhoneRegister': (context) => PhoneSignInPage(),
              '/map': (context) => PharmacyMapPage(),
            },

            //use slef created Splashpage as the first page that appears
            //when starting the app

            home: SplachPage(
              duration: 2,
              goTopage: Wrapper(),
            ),
          )));
}
