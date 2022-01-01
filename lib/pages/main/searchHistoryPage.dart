import 'package:flutter/material.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({Key? key}) : super(key: key);

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
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
                      'Search History Page',
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
            CustomBottomBar()
          ],
        ),
      ),
    );
    // TODO: MAKE PAGE
  }
}
