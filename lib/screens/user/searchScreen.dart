import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/screens/user/resultScreen.dart';
import 'package:medicine/services/database.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/messageWidget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SeacrhScreen extends StatefulWidget {
  String hintText = '';

  SeacrhScreen(this.hintText);

  @override
  State<SeacrhScreen> createState() => _SeacrhScreenState();
}

class _SeacrhScreenState extends State<SeacrhScreen> {
  final TextEditingController searchController = TextEditingController();
  bool resultsCardVis = false;

  @override
  Widget build(BuildContext context) {
    // To hide Status bar, set setEnabledSystemUIMode as immersive
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    String mainText = 'Searching for medicine by their \n${widget.hintText}';

    final queryService = Provider.of<QueryService>(context, listen: false);
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        //drawer: Drawer(),
        body: Container(
          height: height,
          width: width,
          child: Stack(children: [
            Positioned.fill(
              child: Image.asset(
                'assets/imgs/bg3.jpg',
                // fit image across its allowed space
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Container(
                            width: width * 0.2,
                            height: height * 0.2,
                            color: AppColors.MAIN_COLOR,
                            alignment: Alignment.center,
                            child: IconFont(
                              color: Colors.white,
                              iconName: IConFontHelper.LOGO,
                              size: 0.14,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.05,
                        ),
                        child: Text(
                          mainText,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: height * 0.02,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Text field for typing medicine name
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.04,
                          left: width * 0.035,
                          right: width * 0.035,
                          bottom: height * 0.03,
                        ),
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
                            labelText: widget.hintText,
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
                          //First hide the onScreen KB to make the animated container visible
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (widget.hintText == 'Generic name') {
                            await queryService
                                .genericSearch(
                                    searchController.text.toLowerCase())
                                .then((value) => {
                                      if (value == "Success")
                                        {
                                          Database.addSearchHistory(
                                              searchController.text,
                                              "Generic name"),
                                          Database.updateMedicineSearchCounter(
                                              searchController.text),
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultMapPage()))
                                        }
                                      else
                                        {
                                          setState(() {
                                            resultsCardVis = !resultsCardVis;
                                          })
                                        }
                                    });
                          } else {
                            await queryService
                                .brandSearch(
                                    searchController.text.toLowerCase())
                                .then((value) => {
                                      if (value == "Success")
                                        {
                                          Database.addSearchHistory(
                                              searchController.text,
                                              "Brand name"),
                                          Database.updateMedicineSearchCounter(
                                              searchController.text),
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultMapPage()))
                                        }
                                      else
                                        {
                                          setState(() {
                                            resultsCardVis = !resultsCardVis;
                                          })
                                        }
                                    });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(height * 0.025),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.MAIN_COLOR,
                          onPrimary: AppColors.ACCENT,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.5)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.045,
                      ),
                      Visibility(
                        visible: resultsCardVis,
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          onDismissed: (_) => setState(() {
                            resultsCardVis = !resultsCardVis;
                          }),
                          child: MessageWidget(
                            message:
                                "\nThe desired medicine is unavailable in all of the supported pharmacies!",
                          ),
                        ),
                      ),
                    ]),
              ),
            ),

            // CustomBottomBar(),
          ]),
        ));
  }
}
