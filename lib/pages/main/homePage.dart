import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/widgets/searchCategories.dart';
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
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please provide either the "Generic" or the "Brand" name of the medicine you are looking for!\n\nSearch for medicine by',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: height * 0.023,
                      color: AppColors.MAIN_COLOR,
                    ),
                  ),
                  SearchCategory('Generic Name', 'scientificName',
                      IConFontHelper.DR, SearchPage('Generic name')),
                  SearchCategory('Brand Name', 'commonName',
                      IConFontHelper.LAB__BOTTLE, SearchPage('Brand name')),
                  // SearchCategory('Common Diseases in Khartoum', 'khartoum',
                  //     IConFontHelper.LOCATION, CommonDiseases()),
                ],
              ),
            ),
            CustomBottomBar()
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types

