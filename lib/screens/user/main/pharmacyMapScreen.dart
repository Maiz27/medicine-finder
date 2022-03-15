import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicine/helpers/appInfo.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:ui' as ui;

List _pharmacies = [];
List<LatLng> _LatLng = [];
const double PHARMACY_CARD_VISIBLE = 100;
const double PHARMACY_CARD_INVISIBLE = -500;

double currPharmacyLat = 0.0;
double currPharmacyLon = 0.0;

double userLat = 0.0;
double userLon = 0.0;

class PharmacyMapScreen extends StatefulWidget {
  const PharmacyMapScreen({Key? key}) : super(key: key);

  @override
  _PharmacyMapScreenState createState() => _PharmacyMapScreenState();
}

class _PharmacyMapScreenState extends State<PharmacyMapScreen> {
  //setting the initial Camera position for the map view
  //Using project site's location coordinates 'Abeerna Pharmacy'
  static var _initialCameraPosition = CameraPosition(
    target: _LatLng[0],
    zoom: 16,
    tilt: 80,
    bearing: 30,
  );
  late BitmapDescriptor icon;
  Set<Marker> _markers = new Set<Marker>();
  double pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
  String currPharmacyName = "";
  String currPharmacyNum = "";
  int index = 0;

  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    _pharmacies = QueryService.pharmacies;
    setLatLng();
    getCurrLoc();
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
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
              initialCameraPosition: _initialCameraPosition,
              onTap: (LatLng loc) {
                //Tap to dismiss pharmacy card
                setState(() {
                  pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
                });
              },
              onMapCreated: onMapCreated,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: this.pharmacyCardVis,
            child: Container(
              width: width * 0.2,
              height: height * 0.2,
              margin: EdgeInsets.only(
                bottom: height * 0.02,
                left: width * 0.06,
                right: height * 0.06,
              ),
              padding: EdgeInsets.only(
                top: height * 0.02,
                bottom: height * 0.02,
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.02, bottom: height * 0.02),
                        child: Text(
                          currPharmacyName,
                          style: TextStyle(fontSize: height * 0.02),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => {
                          launch(
                              "https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLon&destination=$currPharmacyLat,$currPharmacyLon")
                        },
                        icon: Icon(
                          Icons.directions,
                          size: height * 0.05,
                          color: AppInfo.MAIN_COLOR,
                        ),
                        tooltip: "Directions",
                      ),
                      IconButton(
                        onPressed: () => {launch("tel:$currPharmacyNum")},
                        icon: Icon(
                          Icons.call,
                          size: height * 0.05,
                          color: AppInfo.MAIN_COLOR,
                        ),
                        tooltip: "Call",
                      ),
                    ],
                  )
                ],
              ),
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
                          pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
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
                          pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                      )),
                ],
              ),
            ),
          ),
          CustomBottomBar(),
        ],
      ),
    );
  }

  showPharmaciesOnMap() {
    _pharmacies.forEach((element) {
      currPharmacyLat = element.lat;
      currPharmacyLon = element.lng;
      LatLng pin = new LatLng(currPharmacyLat, currPharmacyLon);

      _markers.add(Marker(
          markerId: MarkerId(element.name),
          position: pin,
          icon: icon,
          onTap: () {
            setState(() {
              currPharmacyName = element.name;
              currPharmacyNum = element.tele;
              index = _pharmacies.indexOf(element);
              this.pharmacyCardVis = PHARMACY_CARD_VISIBLE;
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
    _pharmacies.forEach((element) {
      _LatLng.add(new LatLng(element.lat, element.lng));
    });
  }
}

// Future<Uint8List> getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//       targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//       .buffer
//       .asUint8List();
// }
