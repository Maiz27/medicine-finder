import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/appInfo.dart';
import '../../../helpers/deviceDimensions.dart';
import '../../../helpers/iconHelper.dart';
import '../../../models/medicineModel.dart';
import '../../../services/database.dart';
import '../../../widgets/IconFont.dart';
import '../../../widgets/medicineCard.dart';
import '../../../widgets/messageWidget.dart';
import '../../../widgets/pharmacyDrawer.dart';
import '../editMedicineScreen.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    List<Medicine> _medicineList = Database.getMedicineList();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppInfo.MAIN_COLOR,
        tooltip: "Add New Medicine",
        child: IconFont(
          color: AppInfo.ACCENT,
          size: 0.04,
          iconName: IConFontHelper.ADD,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => EditMedicineScreen(
                      isEdit: "",
                      index: 0,
                    )),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: AppInfo.MAIN_COLOR,
        title: Text("Medicine List"),
        centerTitle: true,
      ),
      drawer: PharmacyDrawer(),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: height * 0.1,
        ),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.02,
                  bottom: height * 0.02,
                ),
                child: Text(
                  'Sorted by: Generic Name',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: width * 0.025,
                    fontWeight: FontWeight.bold,
                    letterSpacing: width * 0.0005,
                  ),
                ),
              ),
            ),
            _medicineList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: _medicineList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return MedicineCard(
                            medicine: _medicineList[index],
                            index: index,
                          );
                        }),
                  )
                : MessageWidget(
                    message:
                        "Medicine List is currently empty!\n\nCreate a New Medicine Document!\n ")
          ],
        ),
      ),
    );
  }
}

// showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return Dialog(
//                                     child: Container(
//                                       width: width * 0.3,
//                                       height: height * 0.35,
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                               top: height * 0.05,
//                                               bottom: height * 0.05,
//                                             ),
//                                             child: Text(
//                                               "Are you sure you want to Delete this Document?\n\n" +
//                                                   _medicineList[index].name,
//                                               softWrap: true,
//                                               style: TextStyle(
//                                                 fontSize: height * 0.02,
//                                                 letterSpacing: width * 0.0005,
//                                               ),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                           Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 IconButton(
//                                                   icon: Icon(
//                                                     Icons.done,
//                                                     size: width * 0.05,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Database()
//                                                         .deleteMedcineDoc(
//                                                             _medicineList[index]
//                                                                 .id
//                                                                 .toString());
//                                                     setState(() {
//                                                       _medicineList
//                                                           .removeAt(index);
//                                                     });
//                                                   },
//                                                 ),
//                                                 IconButton(
//                                                   icon: Icon(
//                                                     Icons.cancel,
//                                                     size: width * 0.05,
//                                                   ),
//                                                   onPressed: () {
//                                                     Navigator.pop(context);
//                                                     setState(() {
//                                                       dismissed = !dismissed;
//                                                     });
//                                                   },
//                                                 ),
//                                               ]),
//                                         ],
//                                       ),
//                                     ),
//                                   );
