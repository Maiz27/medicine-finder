import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/appInfo.dart';
import '../../../helpers/deviceDimensions.dart';
import '../../../models/pharmacyModel.dart';
import '../../../services/database.dart';
import '../../../widgets/pharmacyDrawer.dart';

class PharmacyInfoScreen extends StatelessWidget {
  const PharmacyInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pharmacy? _pharmacy = Database.getCurrPharmacy();
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppInfo.MAIN_COLOR,
          title: Text(_pharmacy!.name),
          centerTitle: true,
        ),
        drawer: PharmacyDrawer(),
        body: Container(
          height: height,
          width: width,
        ));
  }
}
