import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchCategory extends StatelessWidget {
  String label;
  String img;
  String icon;
  Widget gotopage;

  SearchCategory(this.label, this.img, this.icon, this.gotopage);

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => this.gotopage));
      },
      child: Container(
        margin: EdgeInsets.all(20),
        height: height * 0.23,
        padding: EdgeInsets.only(
          left: width * 0.02,
          right: width * 0.02,
          // top: height * 0.035,
          // bottom: height * 0.03,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.03),
                  child: Image.asset(
                    'assets/imgs/' + img + '.jpg',
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(height * 0.03),
                    bottomRight: Radius.circular(height * 0.03),
                  ),
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
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        width: width * 0.06,
                        height: height * 0.06,
                        alignment: Alignment.center,
                        child: IconFont(
                          size: 0.04,
                          color: AppColors.MAIN_COLOR,
                          iconName: icon,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      label,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
