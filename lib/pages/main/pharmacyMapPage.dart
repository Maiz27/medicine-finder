import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:ui' as ui;

List _pharmacies = [];
const double PHARMACY_CARD_VISIBLE = 100;
const double PHARMACY_CARD_INVISIBLE = -500;

class PharmacyMapPage extends StatefulWidget {
  const PharmacyMapPage({Key? key}) : super(key: key);

  @override
  _PharmacyMapPageState createState() => _PharmacyMapPageState();
}

class _PharmacyMapPageState extends State<PharmacyMapPage> {
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
  double pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
  String currPharmacyName = "";
  String currPharmacyNum = "";

  @override
  void initState() {
    super.initState();

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
    final qs = Provider.of<QueryService>(context, listen: false);
    _pharmacies = qs.getPharmacy();
    //Create a google map controller to control the instance of the google map
    Completer<GoogleMapController> _controller = Completer();

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
            markers: _markers,
            initialCameraPosition: _initialCameraPosition,
            onTap: (LatLng loc) {
              //Tap to dismiss pharmacy card
              setState(() {
                pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
              });
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              showPharmaciesOnMap();
            },
          ),
        ),
        AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 10,
            right: 0,
            bottom: this.pharmacyCardVis,
            child: Container(
              width: width * 0.1,
              height: height * 0.1,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconFont(
                      color: AppColors.MAIN_COLOR,
                      size: 0.05,
                      iconName: IConFontHelper.PHARM_lOC),
                  Text(
                    currPharmacyName,
                    style: TextStyle(fontSize: height * 0.02),
                  ),
                  IconButton(
                    onPressed: () => {launch("tel:$currPharmacyNum")},
                    icon: Icon(
                      Icons.call,
                      size: 35,
                      color: AppColors.MAIN_COLOR,
                    ),
                  )
                ],
              ),
            )),
        CustomAppBar()
      ]),
    );
  }

  showPharmaciesOnMap() {
    setState(() {
      _pharmacies.forEach((element) {
        LatLng pin = new LatLng(element.lat, element.lng);
        _markers.add(Marker(
            markerId: MarkerId(element.name),
            position: pin,
            icon: icon,
            onTap: () {
              setState(() {
                currPharmacyName = element.name;
                currPharmacyNum = element.tele;
                this.pharmacyCardVis = PHARMACY_CARD_VISIBLE;
              });
            }));
      });
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
