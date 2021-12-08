import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/models/searchResultModel.dart';
import 'package:medicine/services/queryService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:medicine/widgets/appBar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

List _pharmacies = [];
List _results = [];
List _finalResult = [];
const double PHARMACY_CARD_VISIBLE = 100;
const double PHARMACY_CARD_INVISIBLE = -500;
String currPharmacyName = "";
String currPharmacyNum = "";
String currPharmacyPrice = "";
String searchedMedicine = "";

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
  double pharmacyCardVis = PHARMACY_CARD_INVISIBLE;

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
    final deviceDimensions = Provider.of<Dimension>(context);
    final qs = Provider.of<QueryService>(context, listen: false);

    _pharmacies = qs.getPharmacy();
    _results = qs.getResults();
    combine();

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
            markers: _markers,
            initialCameraPosition: _initialCameraPosition,
            onTap: (LatLng loc) {
              //Tap to dismiss pharmacy card
              setState(() {
                pharmacyCardVis = PHARMACY_CARD_INVISIBLE;
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
        AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 10,
            right: 0,
            bottom: this.pharmacyCardVis,
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
                        iconName: IConFontHelper.PHARM_lOC),
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
                  height: height * 0.05,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        searchedMedicine,
                        style: TextStyle(fontSize: height * 0.02),
                      ),
                      Text(
                        currPharmacyPrice + ' SDG',
                        style: TextStyle(fontSize: height * 0.02),
                      ),
                    ]),
              ]),
            )),
        CustomAppBar()
      ]),
    );
  }

  showPharmaciesOnMap() {
    _finalResult.forEach((element) {
      LatLng pin = new LatLng(element.lat, element.lng);
      _markers.add(Marker(
          markerId: MarkerId(element.pharmacyName),
          position: pin,
          icon: icon,
          onTap: () {
            setState(() {
              currPharmacyName = element.pharmacyName;
              currPharmacyNum = element.tele;
              searchedMedicine = element.medicine;
              currPharmacyPrice = element.price;
              this.pharmacyCardVis = PHARMACY_CARD_VISIBLE;
            });
          }));
    });
  }

  //Method to combine the two lists into one Final Search results lists
  void combine() {
    if (_finalResult.isNotEmpty) {
      _finalResult.clear();
    }
    setState(() {
      _pharmacies.forEach((element) {
        _results.forEach((e) {
          if (e.Pname == element.name) {
            _finalResult.add(FinalResult(
              element.name,
              element.tele,
              element.lat,
              element.lng,
              e.Mname.toString(),
              e.price.toString(),
            ));
          }
        });
      });
    });
  }
}
