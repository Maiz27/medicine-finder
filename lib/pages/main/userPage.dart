import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/utility.dart';
import 'package:medicine/models/userModel.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);
    final utility = Provider.of<Utility>(context);
    CurrUser? _user = utility.getCurrUser();

//TODO: UserInfo is retrieved only when its by phone! for other signin options
// it keeps the same old data! FIX IT
    // try {
    //   _user = phoneAuthService.getCurrUserInfo()!;
    //   if (_user.isEmpty()) {
    //     _user = authService.getCurrUserInfo();
    //   }
    // } catch (e) {
    //   _user = authService.getCurrUserInfo();
    // }
    // ignore: unnecessary_null_comparison

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            bottom: height - (height * 0.9),
            child: Image.asset(
              'assets/imgs/bg2.jpg',
              // fit image across its allowed space
              fit: BoxFit.cover,
            ),
          ),
          Column(children: [
            Text(_user!.fullName),
            Text(_user.email.toString()),
            Text(_user.accType),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/wrapper', (Route<dynamic> route) => false);
                  Navigator.pushReplacementNamed(context, '/wrapper');
                },
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.MAIN_COLOR,
                ),
              ),
            ),
          ]),
          CustomBottomBar(),
        ],
      ),
    );
  }
}
