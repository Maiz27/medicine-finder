import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/appInfo.dart';
import '../../../helpers/deviceDimensions.dart';
import '../../../services/database.dart';
import '../../../widgets/messageWidget.dart';
import '../../../widgets/pharmacyDrawer.dart';
import '../../../widgets/popularMedicineCard.dart';

class PopularMedicinesScreen extends StatelessWidget {
  const PopularMedicinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    var _popularList = Database.getPopularList();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppInfo.MAIN_COLOR,
          title: Text("Popular Medicine"),
          centerTitle: true,
        ),
        drawer: PharmacyDrawer(),
        body: Column(children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.02,
                bottom: height * 0.02,
              ),
              child: Text(
                'Frequently Searched Medicine:',
                softWrap: true,
                style: TextStyle(
                  fontSize: width * 0.025,
                  fontWeight: FontWeight.bold,
                  letterSpacing: width * 0.0005,
                ),
              ),
            ),
          ),
          _popularList!.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: _popularList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return PopularMedicineCard(
                          popular: _popularList[index],
                        );
                      }),
                )
              : MessageWidget(
                  message: "Popular Medicine List is currently empty!\n")
        ]));
  }
}
