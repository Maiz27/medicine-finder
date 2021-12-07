import 'package:flutter/material.dart';
import 'package:medicine/helpers/appColors.dart';

// for the current design, a different kind of button is needed but isn't
// available to work around it, create a container and customize it to make it
//button like must wrap the container in an 'InkWell' widget and a Matrail widget
// the wrapping with the 2 widgets provides button capabilities
// To avoid the button touching the edges, wrap the 'Material' in a container
//and apply the right margines

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  String? text = "";
  Function onClick;

  CustomButton({this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),

      // by defual, material widgets adds edges to any container
      // to avoid that, use 'ClipRRect' to chop off the edges
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            //Provide the splash color, highlight color and the action when tapped
            //Splash & Highligh
            splashColor: AppColors.MAIN_COLOR.withOpacity(0.2),
            highlightColor: AppColors.MAIN_COLOR.withOpacity(0.2),

            // Use 'onTap' for onPressed Capabilities
            onTap: () {
              // ignore: unnecessary_statements
              this.onClick;
            },
            //Wrapping section end

            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                this.text.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.MAIN_COLOR,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Use decoration to customize the container
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  //color transparent property to make the button look transparent with only the border showing
                  color: Colors.transparent,
                  // provide color for the border
                  border: Border.all(
                      //the color argument in boder takes const color values so use hexa-code
                      color: AppColors.MAIN_COLOR,
                      width: 4)),
            ),
          ),
        ),
      ),
    );
  }
}
