import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/appInfo.dart';
import '../helpers/deviceDimensions.dart';
import '../helpers/iconHelper.dart';
import '../models/medicineModel.dart';
import '../screens/pharmacist/editMedicineScreen.dart';
import 'IconFont.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({
    Key? key,
    required this.medicine,
    required this.index,
  }) : super(key: key);
  final Medicine medicine;
  final int index;

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EditMedicineScreen(
                    medicine: medicine,
                    isEdit: "true",
                    index: index,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: height * 0.02,
          left: width * 0.02,
          right: height * 0.02,
        ),
        width: width * 0.45,
        height: height * 0.1,
        decoration: BoxDecoration(
            color: AppInfo.MAIN_COLOR,
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
                color: AppInfo.ACCENT,
                size: 0.04,
                iconName: IConFontHelper.CAN,
              ),
              VerticalDivider(
                color: AppInfo.ACCENT,
                thickness: 2,
                indent: height * 0.01,
                endIndent: height * 0.01,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(medicine.name,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: width * 0.02,
                          fontWeight: FontWeight.bold,
                          letterSpacing: width * 0.0005,
                          color: AppInfo.ACCENT,
                        )),
                    Text(
                      "Price: " + medicine.price.toString(),
                      softWrap: true,
                      style: TextStyle(
                        fontSize: width * 0.02,
                        fontWeight: FontWeight.bold,
                        letterSpacing: width * 0.0005,
                        color: AppInfo.ACCENT,
                      ),
                    ),
                  ]),
              VerticalDivider(
                color: AppInfo.ACCENT,
                thickness: 2,
                indent: height * 0.01,
                endIndent: height * 0.01,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "In-Stock",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: width * 0.02,
                      fontWeight: FontWeight.bold,
                      letterSpacing: width * 0.0005,
                      color: AppInfo.ACCENT,
                    ),
                  ),
                  Text(
                    medicine.inStock.toString(),
                    softWrap: true,
                    style: TextStyle(
                      fontSize: width * 0.02,
                      fontWeight: FontWeight.bold,
                      letterSpacing: width * 0.0005,
                      color: AppInfo.ACCENT,
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
