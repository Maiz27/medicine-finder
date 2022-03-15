import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicine/helpers/appInfo.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

List _finalResult = [];
List _brandNames = [];
List<LatLng> _LatLng = [];

const double RESULTS_CARD_VISIBLE = 100;
const double RESULTS_CARD_INVISIBLE = -500;

String currPharmacyName = "";
String currPharmacyNum = "";
String currPharmacyPrice = "";
String searchedMedicine = "";
String medicineDesc = "";
double currPharmacyLat = 0.0;
double currPharmacyLon = 0.0;

double userLat = 0.0;
double userLon = 0.0;

class ResultMapPage extends StatefulWidget {
  const ResultMapPage({Key? key}) : super(key: key);

  @override
  _ResultMapPageState createState() => _ResultMapPageState();
}

class _ResultMapPageState extends State<ResultMapPage> {
  //setting the initial Camera position for the map view
  //Using project site's location coordinates 'Abeerna Pharmacy'

  static var _initialCameraPosition = CameraPosition(
    target: _LatLng[0],
    zoom: 16,
    tilt: 80,
    bearing: 40,
  );
  late BitmapDescriptor icon;
  Set<Marker> _markers = new Set<Marker>();
  // Set<Polyline> _polylines = new Set<Polyline>();
  // //Each polyline is made up of multiple coordinates,
  // //starts at one and ends at another
  // List<LatLng> polylineCoordinates = [];
  // late PolylinePoints polylinePoints;
  double resultsCardVis = RESULTS_CARD_INVISIBLE;
  bool descOn = false;
  int index = 0;

  //Create a google map controller to control the instance of the google map
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    _finalResult = QueryService.finalSearchResult;
    setLatLng();
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

  onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;

      showPharmaciesOnMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();

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
              onMapCreated: onMapCreated),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          left: 0,
          right: 0,
          bottom: this.resultsCardVis,
          child: Container(
            width: width * 0.2,
            height: descOn ? height * 0.6 : height * 0.4,
            margin: EdgeInsets.only(
              bottom: height * 0.0001,
              left: width * 0.04,
              right: width * 0.04,
            ),
            padding: EdgeInsets.only(
              top: height * 0.02,
              bottom: height * 0.02,
              left: width * 0.02,
              right: width * 0.02,
            ),
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
                    color: AppInfo.MAIN_COLOR,
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
                      color: AppInfo.MAIN_COLOR,
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text(
                  searchedMedicine,
                  style: TextStyle(fontSize: height * 0.02),
                ),
                // Text(
                //   currPharmacyPrice,
                //   style: TextStyle(fontSize: height * 0.02),
                // ),
                IconButton(
                  onPressed: () => {
                    launch(
                        "https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLon&destination=$currPharmacyLat,$currPharmacyLon")
                  },
                  icon: Icon(
                    Icons.directions,
                    size: 35,
                    color: AppInfo.MAIN_COLOR,
                  ),
                ),
              ]),
              Visibility(
                child: Padding(
                  padding: EdgeInsets.all(height * 0.01),
                  child: Text(
                    medicineDesc,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: height * 0.02),
                  ),
                ),
                visible: descOn,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(fontSize: height * 0.02),
                  ),
                  Switch(
                    activeColor: AppInfo.MAIN_COLOR,
                    onChanged: (bool value) {
                      setState(() {
                        descOn = value;
                      });
                    },
                    value: descOn,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.01),
                child: Center(
                  child: Text(
                    "Brand names: ",
                    style: TextStyle(
                        fontSize: height * 0.02, color: AppInfo.MAIN_COLOR),
                  ),
                ),
              ),
              Container(
                height: height * 0.14,
                child: ListView.builder(
                    itemCount: _brandNames.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.01,
                          // bottom: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(_brandNames[index]['name'],
                                style: TextStyle(fontSize: height * 0.022)),
                            _brandNames[index]['inStock']
                                ? IconFont(
                                    color: AppInfo.MAIN_COLOR,
                                    size: 0.045,
                                    iconName: IConFontHelper.INSTOCK)
                                : IconFont(
                                    color: AppInfo.MAIN_COLOR,
                                    size: 0.045,
                                    iconName: IConFontHelper.OUTSTOCK),
                            Text(
                              _brandNames[index]['price'].toString() + " SDG",
                              style: TextStyle(fontSize: height * 0.022),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ]),
          ),
        ),
        Positioned(
          top: height * 0.08,
          left: width * 0.05,
          child: Container(
            width: width * 0.4,
            height: height * 0.1,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.animateCamera(CameraUpdate.newLatLng(
                            _LatLng[(index - 1) % _LatLng.length]));
                        index = (index - 1) % _LatLng.length;
                        this.resultsCardVis = RESULTS_CARD_INVISIBLE;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back,
                    )),
                Text(
                  (index + 1 % _LatLng.length).toString() +
                      " Of " +
                      _LatLng.length.toString(),
                  style: TextStyle(
                    fontSize: height * 0.022,
                    color: AppInfo.MAIN_COLOR,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.animateCamera(CameraUpdate.newLatLng(
                            _LatLng[(index + 1) % _LatLng.length]));
                        index = (index + 1) % _LatLng.length;
                        this.resultsCardVis = RESULTS_CARD_INVISIBLE;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                    )),
              ],
            ),
          ),
        ),
        CustomBottomBar()
      ]),
    );
  }

  showPharmaciesOnMap() {
    _finalResult.forEach((element) {
      searchedMedicine = element.medicine;
      currPharmacyLat = element.lat;
      currPharmacyLon = element.lng;
      _markers.add(Marker(
          markerId: MarkerId(element.pharmacyName),
          position: new LatLng(currPharmacyLat, currPharmacyLon),
          icon: icon,
          onTap: () {
            medicineDesc = element.desc;
            currPharmacyName = element.pharmacyName;
            currPharmacyNum = element.tele;
            currPharmacyLat = element.lat;
            currPharmacyLon = element.lng;
            index = _finalResult.indexOf(element);
            if (_brandNames.isNotEmpty) {
              _brandNames.clear();
            }
            element.brandNames.forEach((e) {
              _brandNames.add(e);
            });
            setState(() {
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

  void setLatLng() {
    if (_LatLng.isNotEmpty) {
      _LatLng.clear();
    }
    _finalResult.forEach((element) {
      _LatLng.add(new LatLng(element.lat, element.lng));
    });
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
  //         color: AppInfo.MAIN_COLOR,
  //         points: polylineCoordinates,
  //       ));
  //     });
  //   }
  // }

  // Visibility(
  //               child: Text(
  //                 "sdasdw",
  //                 style: TextStyle(fontSize: height * 0.02),
  //               ),
  //               visible: descOn,
  //             ),
}
