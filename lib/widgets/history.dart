import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/pages/resultPage.dart';
import 'package:medicine/services/database.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

class SearchHistoryWidget extends StatelessWidget {
  const SearchHistoryWidget({
    Key? key,
    required this.medicine,
    required this.searchedBy,
    required this.someDate,
  }) : super(key: key);

  final String medicine;
  final String searchedBy;
  final DateTime someDate;

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);
    final queryService = Provider.of<QueryService>(context, listen: false);
    if (someDate.isUtc) print("UTC UTC UTC UTC");

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return GestureDetector(
      onTap: () async {
        if (this.searchedBy == "Generic name") {
          await queryService.genericSearch(this.medicine).then((value) => {
                if (value == "Success")
                  {
                    Database.addSearchHistory(medicine, "Generic name"),
                    Database.updateMedicineSearchCounter(medicine),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultMapPage()))
                  }
                else
                  {Fluttertoast.showToast(msg: "Medicine not available!")}
              });
        } else {
          await queryService.brandSearch(this.medicine).then((value) => {
                if (value == "Success")
                  {
                    Database.addSearchHistory(medicine, "Generic name"),
                    Database.updateMedicineSearchCounter(medicine),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultMapPage()))
                  }
                else
                  {Fluttertoast.showToast(msg: "Medicine not available!")}
              });
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: height * 0.02,
          left: width * 0.015,
          right: height * 0.015,
        ),
        width: width * 0.45,
        height: height * 0.1,
        decoration: BoxDecoration(
            color: AppColors.MAIN_COLOR,
            borderRadius: BorderRadius.all(
              Radius.circular(height * 0.03),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset.zero,
              )
            ]),
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconFont(
                color: AppColors.ACCENT,
                size: 0.04,
                iconName: IConFontHelper.SEARCH,
              ),
              VerticalDivider(
                color: AppColors.ACCENT,
                thickness: 2,
                indent: height * 0.01,
                endIndent: height * 0.01,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(medicine,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: width * 0.02,
                          fontWeight: FontWeight.bold,
                          letterSpacing: width * 0.0005,
                          color: AppColors.ACCENT,
                        )),
                    Text(
                      searchedBy,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: width * 0.02,
                        fontWeight: FontWeight.bold,
                        letterSpacing: width * 0.0005,
                        color: AppColors.ACCENT,
                      ),
                    ),
                  ]),
              VerticalDivider(
                color: AppColors.ACCENT,
                thickness: 2,
                indent: height * 0.01,
                endIndent: height * 0.01,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    DateFormat.jm().format(someDate),
                    softWrap: true,
                    style: TextStyle(
                      fontSize: width * 0.02,
                      fontWeight: FontWeight.bold,
                      letterSpacing: width * 0.0005,
                      color: AppColors.ACCENT,
                    ),
                  ),
                  Text(
                    DateFormat.yMd().format(someDate),
                    softWrap: true,
                    style: TextStyle(
                      fontSize: width * 0.02,
                      fontWeight: FontWeight.bold,
                      letterSpacing: width * 0.0005,
                      color: AppColors.ACCENT,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
