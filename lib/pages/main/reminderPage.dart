import 'package:flutter/material.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
                bottom: height - (height * 0.9),
                child: Image.asset(
                  'assets/imgs/bg5.jpg',
                  // fit image across its allowed space
                  fit: BoxFit.cover,
                )),
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text(
                      'Reminder Alarm Page',
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
            CustomAppBar()
          ],
        ),
      ),
    );
    // TODO: MAKE PAGE
  }
}
