import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/models/searchResultModel.dart';
import 'package:medicine/widgets/IconFont.dart';

// ignore: must_be_immutable
class ResultCard extends StatelessWidget {
  late Results results;
  Function onCardClick;

  ResultCard({required this.results, required this.onCardClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ignore: unnecessary_statements
        this.onCardClick;
      },
      child: Container(
        margin: EdgeInsets.all(20),
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/imgs/pharmacy.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent
                      ]),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          child: IconFont(
                            size: 35,
                            color: AppColors.MAIN_COLOR,
                            iconName: IConFontHelper.LOCATION,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        this.results.Pname!,
                        style: TextStyle(
                          color: AppColors.MAIN_COLOR,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 35,
                ),
                Row(children: [
                  Text(
                    this.results.Mname!,
                    style: TextStyle(
                      color: AppColors.MAIN_COLOR,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    this.results.price.toString() + ' SDG',
                    style: TextStyle(
                      color: AppColors.MAIN_COLOR,
                      fontSize: 25,
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  )
                ])
              ]),
            )
          ],
        ),
      ),
    );
  }
}
