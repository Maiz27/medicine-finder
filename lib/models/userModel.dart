// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class CurrUser {
  String uid;
  String? email;
  String fullName;
  String? tele;
  Timestamp dateCreated;
  String accType;
  String? imgURL;
  bool isPharmacist;
  String pharmacyId;

  CurrUser({
    required this.uid,
    this.email,
    required this.fullName,
    this.tele,
    required this.dateCreated,
    required this.accType,
    required this.imgURL,
    this.isPharmacist = false,
    this.pharmacyId = "",
  });

  factory CurrUser.fromJson(Map<dynamic, dynamic> doc) {
    return CurrUser(
      uid: doc['uid'],
      fullName: doc['fullName'],
      dateCreated: doc['createdOn'],
      accType: doc['accType'],
      email: doc['email'],
      tele: doc['telephone'],
      imgURL: doc['imgURL'],
      isPharmacist: doc['isPharmacist'],
      pharmacyId: doc['pharmacyId'],
    );
  }

  bool isGoogleAcc() {
    if (accType == "Google") {
      return true;
    }
    return false;
  }

  bool isEmailAcc() {
    if (accType == "Email") {
      return true;
    }
    return false;
  }

  bool isPharmacistAcc() {
    return this.isPharmacist;
  }
}
