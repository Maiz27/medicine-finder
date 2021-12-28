import 'package:flutter/material.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/widgets/searchCategories.dart';
import 'package:medicine/pages/commonDiseasesPage.dart';
import 'package:medicine/pages/searchPage.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  'Search for medicine by',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height * 0.023,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SearchCategory('Generic Name', 'scientificName',
                        IConFontHelper.DR, SearchPage('Generic names')),
                    SearchCategory('Brand Name', 'commonName',
                        IConFontHelper.MOR, SearchPage('Brand names')),
                    SearchCategory('Common Diseases in Khartoum', 'khartoum',
                        IConFontHelper.LOCATION, CommonDiseases()),
                  ],
                ),
              ),
            ],
          ),
        ),
        CustomBottomBar()
      ],
    ));
  }
}

// ignore: camel_case_types

