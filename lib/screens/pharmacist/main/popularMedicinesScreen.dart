import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../helpers/appInfo.dart';
import '../../../helpers/deviceDimensions.dart';
import '../../../helpers/iconHelper.dart';
import '../../../models/medicineModel.dart';
import '../../../services/database.dart';
import '../../../services/queryService.dart';
import '../../../widgets/IconFont.dart';
import '../../../widgets/messageWidget.dart';
import '../../../widgets/pharmacyDrawer.dart';
import '../../../widgets/popularMedicineCard.dart';
import '../reportScreen.dart';

class PopularMedicinesScreen extends StatefulWidget {
  const PopularMedicinesScreen({Key? key}) : super(key: key);

  @override
  State<PopularMedicinesScreen> createState() => _PopularMedicinesScreenState();
}

class _PopularMedicinesScreenState extends State<PopularMedicinesScreen> {
  final TextEditingController searchController = new TextEditingController();
  bool isSearching = false;
  List<PopularMedicine> searchedList = [];

  @override
  Widget build(BuildContext context) {
    final queryService = Provider.of<QueryService>(context, listen: false);
    final deviceDimensions = Provider.of<Dimension>(context);

    var _popularList = Database.getPopularList();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            overlayOpacity: 0.5,
            backgroundColor: AppInfo.ACCENT,
            foregroundColor: AppInfo.MAIN_COLOR,
            children: [
              SpeedDialChild(
                label: "This Week",
                onTap: () async => {
                  await queryService.popularBasedOnDate(1),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReportScreen(text: "This Week")),
                  )
                },
              ),
              SpeedDialChild(
                  label: "This Month",
                  onTap: () async => {
                        await queryService.popularBasedOnDate(2),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ReportScreen(text: "This Month")),
                        )
                      }),
              SpeedDialChild(
                  label: "Last 3 Month",
                  onTap: () async => {
                        await queryService.popularBasedOnDate(3),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ReportScreen(text: "Last 3 Month")),
                        )
                      }),
              SpeedDialChild(
                  label: "Last 6 Month",
                  onTap: () async => {
                        await queryService.popularBasedOnDate(4),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ReportScreen(text: "Last 6 Month")),
                        )
                      }),
              SpeedDialChild(
                  label: "This Year",
                  onTap: () async => {
                        await queryService.popularBasedOnDate(5),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ReportScreen(text: "This Year")),
                        )
                      }),
            ]),
        appBar: AppBar(
          backgroundColor: AppInfo.MAIN_COLOR,
          title: isSearching
              ? TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Search Medicine',
                      hintStyle: TextStyle(color: Colors.white)),
                  controller: searchController,
                  onChanged: (value) {
                    if (value != "" || value.isNotEmpty) {
                      searchedList.clear();
                      var r = _popularList
                          .where((element) => element.name.startsWith(value));
                      r.forEach((element) => {searchedList.add(element)});
                      setState(() {});
                    } else {
                      setState(() {
                        searchedList.clear();
                      });
                    }
                  },
                )
              : Text("Popular Medicine"),
          centerTitle: true,
          actions: [
            isSearching
                ? IconButton(
                    icon: Padding(
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: Icon(Icons.cancel)),
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        searchedList.clear();
                        isSearching = !isSearching;
                      });
                    },
                  )
                : IconButton(
                    icon: Padding(
                      padding: EdgeInsets.only(right: width * 0.05),
                      child: IconFont(
                        color: Colors.white,
                        size: 0.04,
                        iconName: IConFontHelper.SEARCH,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                  )
          ],
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
                'Searched Medicines: All time',
                softWrap: true,
                style: TextStyle(
                  fontSize: width * 0.025,
                  fontWeight: FontWeight.bold,
                  letterSpacing: width * 0.0005,
                ),
              ),
            ),
          ),
          _popularList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: searchedList.isNotEmpty
                          ? searchedList.length
                          : _popularList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return PopularMedicineCard(
                            popular: searchedList.isNotEmpty
                                ? searchedList[index]
                                : _popularList[index]);
                      }),
                )
              : MessageWidget(
                  message: "Popular Medicine List is currently empty!\n")
        ]));
  }
}
