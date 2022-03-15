import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/appInfo.dart';
import '../../helpers/deviceDimensions.dart';
import '../../helpers/iconHelper.dart';
import '../../models/medicineModel.dart';
import '../../services/queryService.dart';
import '../../widgets/IconFont.dart';
import '../../widgets/messageWidget.dart';
import '../../widgets/popularMedicineCard.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController searchController = new TextEditingController();

  bool isSearching = false;

  List<PopularMedicine> searchedList = [];

  @override
  Widget build(BuildContext context) {
    final queryService = Provider.of<QueryService>(context, listen: false);
    final deviceDimensions = Provider.of<Dimension>(context);

    var _popularList = queryService.getPopular();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    return Scaffold(
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
              : Text("Sorted Popular Medicine"),
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
        body: Column(children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.02,
                bottom: height * 0.02,
              ),
              child: Text(
                'Searched Medicine: ${widget.text}',
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
                  message: "No Searched medicines for the given time\n")
        ]));
  }
}
