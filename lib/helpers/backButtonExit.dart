import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BackButtonExit extends StatefulWidget {
  const BackButtonExit({Key? key}) : super(key: key);

  @override
  _BackButtonExitState createState() => _BackButtonExitState();
}

class _BackButtonExitState extends State<BackButtonExit> {
//use DateTime to the time the user pressed the back button
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // checks the amount of time between back button presses
        final difference = DateTime.now().difference(timeBackPressed);

        // show message to confirm if user wants to exit (if difference is greater than 2)
        final isExitWarning = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          final msg = 'Press back again to exit!';
          Fluttertoast.showToast(msg: msg, fontSize: 18, timeInSecForIosWeb: 5);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(),
    );
  }
}
