import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicine/helpers/appColors.dart';
import 'package:medicine/helpers/deviceDimensions.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/services/authService.dart';
import 'package:medicine/widgets/IconFont.dart';
import 'package:provider/provider.dart';

double pharmacyLat = 0.0;
double pharmacyLng = 0.0;

class PharmacistSignup extends StatefulWidget {
  const PharmacistSignup({Key? key}) : super(key: key);

  @override
  State<PharmacistSignup> createState() => _PharmacistSignupState();
}

class _PharmacistSignupState extends State<PharmacistSignup> {
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pharmacyPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pharmacyLocController = TextEditingController();

  bool useCurrentLoc = true;
  bool isHiddenPW = true;
  // String apiKey = "AIzaSyDMEcd_N55eY460vNl2FmVMZqxFkMQcGAk";
  // GoogleMapsPlaces _places = GoogleMapsPlaces();

  @override
  void initState() {
    getCurrLoc();
    super.initState();
    // polylinePoints = PolylinePoints();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    return Scaffold(
      // To remove 'Bottom Overflowed by....' error
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.black,
        width: width,
        height: height,
        child: Stack(children: [
          Positioned.fill(
              // use opacity to dim image
              child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/imgs/bg.jpg',
              // fit image across its allowed space
              fit: BoxFit.cover,
            ),
          )),
          Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.02,
                ),
                child: Column(children: [
                  Center(
                    child: ClipOval(
                      child: Container(
                        width: width * 0.2,
                        height: height * 0.2,
                        color: AppColors.MAIN_COLOR,
                        alignment: Alignment.center,

                        // use self created 'IconFont class' to get icon from specified font
                        child: IconFont(
                          color: Colors.white,
                          iconName: IConFontHelper.LOGO,
                          size: 0.15,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                      bottom: height * 0.03,
                    ),
                    child: Text(
                      "Fill out the form to\nregister your Pharmcist Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: pharmacyNameController,
                    cursorColor: AppColors.ACCENT,
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Pharmacy Name',
                      prefixIcon: Icon(
                        Icons.store,
                        color: AppColors.ACCENT,
                      ),
                      labelStyle: TextStyle(
                        fontSize: height * 0.02,
                        color: AppColors.ACCENT,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                    ),
                    child: TextField(
                      controller: emailController,
                      cursorColor: AppColors.ACCENT,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.ACCENT,
                        ),
                        labelStyle: TextStyle(
                          fontSize: height * 0.02,
                          color: AppColors.ACCENT,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                    ),
                    child: TextField(
                      controller: pharmacyPhoneController,
                      cursorColor: AppColors.ACCENT,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: AppColors.ACCENT,
                        ),
                        labelStyle: TextStyle(
                          fontSize: height * 0.02,
                          color: AppColors.ACCENT,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                    ),
                    child: TextField(
                      controller: passwordController,
                      cursorColor: AppColors.ACCENT,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.password,
                          color: AppColors.ACCENT,
                        ),
                        suffixIcon: IconButton(
                          icon: isHiddenPW
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isHiddenPW = !isHiddenPW;
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                          fontSize: height * 0.02,
                          color: AppColors.ACCENT,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      obscureText: isHiddenPW,
                    ),
                  ),
                  Visibility(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.03,
                      ),
                      child: TextField(
                        controller: pharmacyLocController,
                        cursorColor: AppColors.ACCENT,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: 'Pharmacy Location',
                          prefixIcon: Icon(
                            Icons.location_pin,
                            color: AppColors.ACCENT,
                          ),
                          labelStyle: TextStyle(
                            fontSize: height * 0.02,
                            color: AppColors.ACCENT,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        // onTap: () async {
                        //   // Prediction? p = await PlacesAutocomplete.show(
                        //   //     context: context,
                        //   //     apiKey: apiKey,
                        //   //     mode: Mode.overlay,
                        //   //     strictbounds: false,
                        //   //     onError: null);
                        //   // displayPrediction(p);
                        // }
                      ),
                    ),
                    visible: !useCurrentLoc,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Use current location\nas Pharmacy's location : ",
                          style: TextStyle(
                            fontSize: width * 0.02,
                            fontWeight: FontWeight.bold,
                            letterSpacing: width * 0.0005,
                            color: AppColors.ACCENT,
                          ),
                        ),
                        Switch(
                            activeColor: AppColors.ACCENT,
                            activeTrackColor: AppColors.MAIN_COLOR,
                            value: useCurrentLoc,
                            onChanged: (newValue) {
                              setState(() {
                                useCurrentLoc = newValue;
                              });
                            }),
                      ],
                    ),
                  ),

                  // Button section
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        authService.createPharmacy(
                          name: pharmacyNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          phone: pharmacyPhoneController.text,
                          lat: pharmacyLat,
                          lng: pharmacyLng,
                        );

                        // Navigator.pushReplacementNamed(context, '/wrapper');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.MAIN_COLOR,
                        onPrimary: AppColors.ACCENT,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.5)),
                        ),
                      ),
                      //add padding to provide space between text
                      //and button borders
                      child: Padding(
                        padding: EdgeInsets.all(height * 0.03),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: AppColors.ACCENT,
                            fontFamily: 'Roboto',
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void getCurrLoc() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    pharmacyLat = position.latitude;
    pharmacyLng = position.longitude;
  }

  // Future<Null> displayPrediction(Prediction? p) async {
  //   if (p != null) {
  //     PlacesDetailsResponse detail =
  //         await _places.getDetailsByPlaceId(p.placeId.toString());

  //     var placeId = p.placeId;

  //     var address = detail.result.formattedAddress;

  //     print(address);

  //     setState(() {
  //       pharmacyLocController.text = address.toString();
  //     });
  //   }
  // }
}
