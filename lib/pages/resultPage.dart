import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine/models/searchResultModel.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/resultCard.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ResultsPage extends StatelessWidget {
  //const ResultsPage({ Key? key }) : super(key: key);

  List<Results> results = [];
  String queriedMed = '';

  ResultsPage(this.queriedMed);

  @override
  Widget build(BuildContext context) {
    // To hide Status bar, set setEnabledSystemUIMode as immersive
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    QueryService queryService =
        Provider.of<QueryService>(context, listen: false);
    results = queryService.getResults();

    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Search results for $queriedMed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ResultCard(
                  results: results[index],
                  onCardClick: () {
                    //TO navigate to map page
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
