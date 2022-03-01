import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine/helpers/appInfo.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/models/historyModel.dart';
import 'package:medicine/services/database.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/bottomNavBar.dart';
import 'package:medicine/widgets/historyCard.dart';
import 'package:medicine/widgets/messageWidget.dart';
import 'package:provider/provider.dart';

List<SearchHistory> history = Database().getSearchHistory();

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({Key? key}) : super(key: key);

  @override
  _SearchHistoryScreenState createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    bool hasHistory = history.isNotEmpty;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              bottom: height - (height * 0.9),
              child: Image.asset(
                'assets/imgs/bg5.jpg',
                // fit image across its allowed space
                fit: BoxFit.cover,
              )),
          Positioned(
            right: width * 0.02,
            top: height * 0.035,
            child: IconButton(
              icon: IconFont(
                color: AppInfo.MAIN_COLOR,
                size: 0.03,
                iconName: IConFontHelper.Delete,
              ),
              tooltip: "Clear History",
              onPressed: () async {
                await Database().deleteAllSearchHistory();
                setState(() {
                  history.clear();
                  Fluttertoast.showToast(msg: "Search history deleted!");
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: height * 0.1,
            ),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.05,
                      bottom: height * 0.02,
                    ),
                    child: Text(
                      'Search History: ',
                      style: TextStyle(
                        fontSize: width * 0.025,
                        fontWeight: FontWeight.bold,
                        letterSpacing: width * 0.0005,
                      ),
                    ),
                  ),
                ),
                hasHistory
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return Dismissible(
                                key: Key(history[index].hashCode.toString()),
                                direction: DismissDirection.horizontal,
                                onDismissed: (DismissDirection d) async {
                                  await Database().deleteSearchHistory(
                                      history[index].id.toString());
                                  setState(() {
                                    history.removeAt(index);
                                  });
                                },
                                child: SearchHistoryWidget(
                                  medicine: history[index].name.toString(),
                                  searchedBy:
                                      history[index].searchedBy.toString(),
                                  someDate: history[index]
                                      .searchedOn!
                                      .toDate()
                                      .toUtc()
                                      .add(Duration(hours: 2)),
                                ),
                              );
                            }),
                      )
                    : MessageWidget(
                        message:
                            "Search history is currently empty!\n\nSuccessfully searched medicine will appear here!\n ")
              ],
            ),
          ),
          CustomBottomBar()
        ],
      ),
    );
  }
}
