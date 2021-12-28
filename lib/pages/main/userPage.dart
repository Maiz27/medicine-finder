import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/services/auth_services.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);

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
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
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
