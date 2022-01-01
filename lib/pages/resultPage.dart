import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

List _finalResult = [];
const double RESULTS_CARD_VISIBLE = 100;
const double RESULTS_CARD_INVISIBLE = -500;

String currPharmacyName = "";
String currPharmacyNum = "";
String currPharmacyPrice = "";
String searchedMedicine = "";
double currPharmacyLat = 0.0;
double currPharmacyLon = 0.0;

double userLat = 0.0;
double userLon = 0.0;

class ResultMapPage extends StatefulWidget {
  const ResultMapPage({
    Key? key,
  }) : super(key: key);

  @override
  _ResultMapPageState createState() => _ResultMapPageState();
}

class _ResultMapPageState extends State<ResultMapPage> {
  //setting the initial Camera position for the map view
  //Using project site's location coordinates 'Abeerna Pharmacy'
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(15.577004480574697, 32.56923054149381),
    zoom: 16,
    tilt: 80,
    bearing: 30,
  );
  late BitmapDescriptor icon;
  Set<Marker> _markers = new Set<Marker>();
  // Set<Polyline> _polylines = new Set<Polyline>();
  // //Each polyline is made up of multiple coordinates,
  // //starts at one and ends at another
  // List<LatLng> polylineCoordinates = [];
  // late PolylinePoints polylinePoints;
  double resultsCardVis = RESULTS_CARD_INVISIBLE;

  @override
  void initState() {
    super.initState();
    getCurrLoc();
    // polylinePoints = PolylinePoints();

    this.setSourceIcon();
  }

  void setSourceIcon() async {
    // Uint8List markerIcon = await getBytesFromAsset('assets/imgs/pin.png', 300);
    // icon = BitmapDescriptor.fromBytes(markerIcon);
    icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/imgs/pin3.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);
    final qs = Provider.of<QueryService>(context, listen: false);

    _finalResult = qs.getResults();

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

    //Create a google map controller to control the instance of the google map
    Completer<GoogleMapController> _controller = Completer();

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            // polylines: _polylines,
            markers: _markers,
            initialCameraPosition: _initialCameraPosition,
            onTap: (LatLng loc) {
              //Tap to dismiss pharmacy card
              setState(() {
                resultsCardVis = RESULTS_CARD_INVISIBLE;
              });
            },
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                showPharmaciesOnMap();
                _controller.complete(controller);
              });
            },
          ),
        ),
// Before displaying any Result card, first check if the search for medication
// was successfully or not then display the appropriate card
        _finalResult.isEmpty
            ? Center(
                child: Container(
                  width: width * 0.3,
                  height: height * 0.17,
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset.zero,
                        )
                      ]),
                  child: Text(
                    "\nThe desired medicine is unavailable in all of the supported pharmacies!",
                    style: TextStyle(
                      fontSize: height * 0.02,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: this.resultsCardVis,
                child: Container(
                  width: width * 0.2,
                  height: height * 0.2,
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset.zero,
                        )
                      ]),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconFont(
                          color: AppColors.MAIN_COLOR,
                          size: 0.05,
                          iconName: IConFontHelper.PHARM_lOC,
                        ),
                        Text(
                          currPharmacyName,
                          style: TextStyle(
                            fontSize: height * 0.02,
                          ),
                        ),
                        IconButton(
                          onPressed: () => {launch("tel:$currPharmacyNum")},
                          icon: Icon(
                            Icons.call,
                            size: 35,
                            color: AppColors.MAIN_COLOR,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            searchedMedicine,
                            style: TextStyle(fontSize: height * 0.02),
                          ),
                          Text(
                            currPharmacyPrice,
                            style: TextStyle(fontSize: height * 0.02),
                          ),
                          IconButton(
                            onPressed: () => {
                              launch(
                                  "https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLon&destination=$currPharmacyLat,$currPharmacyLon")
                            },
                            icon: Icon(
                              Icons.directions,
                              size: 35,
                              color: AppColors.MAIN_COLOR,
                            ),
                          ),
                        ]),
                  ]),
                ),
              ),
        CustomBottomBar()
      ]),
    );
  }

  showPharmaciesOnMap() {
    _finalResult.forEach((element) {
      currPharmacyLat = element.lat;
      currPharmacyLon = element.lng;
      _markers.add(Marker(
          markerId: MarkerId(element.pharmacyName),
          position: new LatLng(currPharmacyLat, currPharmacyLon),
          icon: icon,
          onTap: () {
            setState(() {
              currPharmacyName = element.pharmacyName;
              currPharmacyNum = element.tele;
              searchedMedicine = element.medicine;
              currPharmacyPrice = element.price + " SDG";

              this.resultsCardVis = RESULTS_CARD_VISIBLE;
            });
          }));
    });
  }

  void getCurrLoc() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userLat = position.latitude;
    userLon = position.longitude;
  }

  //Due to Google Directions API needing a Billing account with credit card info,
//i have opted to using the url_launcher package to open google map instead of
// the below code

  // void setPolyinesOnMap() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       "AIzaSyDMEcd_N55eY460vNl2FmVMZqxFkMQcGAk", // API key
  //       PointLatLng(userLat, userLon),
  //       PointLatLng(currPharmacyLat, currPharmacyLon));

  //   if (result.status == "OK") {
  //     result.points.forEach((element) {
  //       polylineCoordinates.add(LatLng(element.latitude, element.longitude));
  //     });

  //     setState(() {
  //       _polylines.add(Polyline(
  //         width: 10,
  //         polylineId: PolylineId("polyline"),
  //         color: AppColors.MAIN_COLOR,
  //         points: polylineCoordinates,
  //       ));
  //     });
  //   }
  // }
}
