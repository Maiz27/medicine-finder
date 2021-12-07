// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  String name;
  String tele;
  GeoPoint loc;
  double lat;
  double lng;

  Pharmacy(
      {required this.name,
      required this.tele,
      required this.loc,
      required this.lat,
      required this.lng});

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
        name: json['Pharmacy name'],
        tele: json['telephone'],
        loc: json['LATLNG'],
        lat: json['Lat'],
        lng: json['Lng']);
  }
}
