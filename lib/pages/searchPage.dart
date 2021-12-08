import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/pages/resultPage.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  String hintText = '';

  SearchPage(this.hintText);

  @override
  Widget build(BuildContext context) {
    // To hide Status bar, set setEnabledSystemUIMode as immersive
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    final TextEditingController searchController = TextEditingController();
    String mainText = 'Searching for medicine by their $hintText';

    final queryService = Provider.of<QueryService>(context, listen: false);
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        //drawer: Drawer(),
        body: Container(
          height: height,
          width: width,
          child: Stack(children: [
            Positioned.fill(
              bottom: height - (height * 0.9),
              child: Image.asset(
                'assets/imgs/bg3.jpg',
                // fit image across its allowed space
                fit: BoxFit.cover,
              ),
            ),
            // App logo with padding at the all around
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: ClipOval(
                  child: Container(
                    width: width * 0.22,
                    height: height * 0.22,
                    color: AppColors.MAIN_COLOR,
                    alignment: Alignment.center,

                    // use self created 'IconFont class' to get icon from specified font
                    child: IconFont(
                      color: Colors.white,
                      iconName: IConFontHelper.LOGO,
                      size: 0.15,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: height * 0.05,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  mainText,
                  style: TextStyle(
                    fontSize: height * 0.02,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: height * 0.05,
              ),
              // Text field for typing medicine name
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: searchController,
                  cursorColor: AppColors.MAIN_COLOR,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: hintText,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      //using self created IconFont class to use pre made icons
                      child: IconFont(
                        color: AppColors.ACCENT,
                        size: 0.05,
                        iconName: IConFontHelper.CAN,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: height * 0.02,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),

              // Search button
              ElevatedButton(
                onPressed: () async {
                  if (hintText == 'Generic names') {
                    await queryService.scientificSearch(searchController.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultMapPage()));
                  } else {
                    //TODO: Make brand name search method
                  }
                },
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.MAIN_COLOR,
                ),
              ),
              SizedBox(
                height: height * 0.3,
              )
            ]),
            CustomAppBar(),
          ]),
        ));
  }
}
