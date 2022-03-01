import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine/models/historyModel.dart';
import 'package:medicine/models/pharmacyModel.dart';
import 'package:medicine/models/medicineModel.dart';
import 'package:medicine/models/userModel.dart';

class Database {
  static CurrUser? _currUser;
  static Pharmacy? _currPharmacy;
  static bool isPharmacist = false;
  static var _subCollectionRef;
  static var _medicineSubCollectionRef;

  static final _popularMedicineRef =
      FirebaseFirestore.instance.collection('PopularMedicine');

  static List<SearchHistory> _searchHistory = [];

  static List<Medicine> _medicine = [];

  static List<PopularMedicine> _popular = [];

  static setCurrUser(CurrUser currUser) {
    _currUser = currUser;
  }

  static CurrUser? getCurrUser() {
    return _currUser;
  }

  List<SearchHistory> getSearchHistory() {
    return _searchHistory;
  }

  static setUserSubCollectionRef(String currUserID) {
    _subCollectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currUserID)
        .collection("Search History");
  }

  static Future<String> createUser(CurrUser _user) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance.collection('Users').doc(_user.uid).set(
        {
          'fullName': _user.fullName,
          'email': _user.email,
          'uid': _user.uid,
          'createdOn': _user.dateCreated,
          'telephone': _user.tele,
          'accType': _user.accType,
          'imgURL': _user.imgURL,
        },
      );
      retVal = "success";
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    return retVal;
  }

  static Future<Map> getUserDoc(String currUserID) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currUserID)
        .get();

    var data = snap.data() as Map;
    CurrUser user = CurrUser.fromJson(data);
    Database.setCurrUser(user);
    return data;
  }

  static addSearchHistory(String medicine, String searchedBy) async {
    String docId = _subCollectionRef.doc().id;

    try {
      _subCollectionRef.doc(docId).set({
        'id': docId,
        'name': medicine,
        'searchedOn': Timestamp.now(),
        'searchedBy': searchedBy,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static updatePopularMedicineCollection(String medicine) async {
    try {
      var snap = await _popularMedicineRef
          .where('medicine name', isEqualTo: medicine)
          .get();

      if (snap.size > 0) {
        String docID = snap.docs[0].id;
        _popularMedicineRef
            .doc(docID)
            .update({'search counter': FieldValue.increment(1)});
      } else {
        _popularMedicineRef.add({
          'medicine name': medicine,
          'search counter': FieldValue.increment(1)
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future getUserHistory() async {
    var q =
        await _subCollectionRef.orderBy('searchedOn', descending: true).get();

    if (q.size > 0) {
      //Convert query result to a list to loop through them
      List results = q.docs.map((e) => e.data()).toList();

      //First check if the list is empty or not before converting
      //results to dart models
      if (_searchHistory.isNotEmpty) {
        _searchHistory.clear();
      }
      results.forEach((element) {
        //Convert list of results to model dart models
        SearchHistory r = SearchHistory.fromJson(element);
        _searchHistory.add(r);
      });
      return "Success";
    } else {
      return "Failure";
    }
  }

  Future deleteSearchHistory(String id) async {
    try {
      _subCollectionRef.doc(id).delete();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future deleteAllSearchHistory() async {
    await _subCollectionRef.get().then((collection) {
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in collection.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    });
  }

  /* 
    Pharmacist Database Functions are below
  */

  static Future<Map> getPharmacyDoc(String pharmacyID) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Pharmacies')
        .doc(pharmacyID)
        .get();

    var data = snap.data() as Map;
    Pharmacy user = Pharmacy.fromJson(data);
    Database.setCurrPharmacy(user);
    Database.setPharmacySubCollectionRef(user.id);
    return data;
  }

  static void setCurrPharmacy(Pharmacy user) {
    _currPharmacy = user;
  }

  static Pharmacy? getCurrPharmacy() {
    return _currPharmacy;
  }

  static List<Medicine> getMedicineList() {
    return _medicine;
  }

  static List<PopularMedicine>? getPopularList() {
    return _popular;
  }

  static setPharmacySubCollectionRef(String currPharmacyID) {
    _medicineSubCollectionRef = FirebaseFirestore.instance
        .collection('Pharmacies')
        .doc(currPharmacyID)
        .collection('medicine');
  }

  static Future getMedicineFromFirestore() async {
    var q = await _medicineSubCollectionRef
        .orderBy('generic name', descending: false)
        .get();

    if (q.size > 0) {
      //Convert query result to a list to loop through them
      List results = q.docs.map((e) => e.data()).toList();

      //First check if the list is empty or not before converting
      //results to dart models
      if (_medicine.isNotEmpty) {
        _medicine.clear();
      }
      results.forEach((element) {
        //Convert list of results to model dart models
        Medicine r = Medicine.fromJson(element);
        _medicine.add(r);
      });
      return "Success";
    } else {
      return "Failure";
    }
  }

  Future deleteMedcineDoc(String id) async {
    try {
      _medicineSubCollectionRef.doc(id).delete();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future getPopularMedicineCollection() async {
    var q = await _popularMedicineRef
        .orderBy("search counter", descending: true)
        .get();
    if (q.size > 0) {
      //Convert query result to a list to loop through them
      List results = q.docs.map((e) => e.data()).toList();

      //First check if the list is empty or not before converting
      //results to dart models
      if (_popular.isNotEmpty) {
        _popular.clear();
      }
      results.forEach((element) {
        //Convert list of results to model dart models
        PopularMedicine r = PopularMedicine.fromJson(element);
        _popular.add(r);
      });
      return "Success";
    } else {
      return "Failure";
    }
  }

  static Future updateMedicineDoc(
      {required Medicine? medicine,
      required int localListIndex,
      required List<bool> operation,
      List? removedBrandNames}) async {
    try {
      await _medicineSubCollectionRef.doc(medicine!.id).get().then((value) {
        if (value["generic name"] == medicine.name &&
            value["price"] == medicine.price &&
            value["inStock"] == medicine.inStock &&
            value["brand names"] == medicine.brandNames) {
          Fluttertoast.showToast(
              msg: "Updated Failed! No changes to document.");
          return "Error";
        }
        if (value["generic name"] != medicine.name) {
          _medicineSubCollectionRef.doc(medicine.id).update(
            {
              "generic name": medicine.name,
            },
          );
        }
        if (value["price"] != medicine.price) {
          _medicineSubCollectionRef.doc(medicine.id).update({
            "price": medicine.price,
          });
        }
        if (value["inStock"] != medicine.inStock) {
          _medicineSubCollectionRef.doc(medicine.id).update({
            "inStock": medicine.inStock,
          });
        }
        if (value["brand names"] != medicine.brandNames) {
          Database.updateBrandNamesArry(medicine, removedBrandNames, operation);
        }

        Fluttertoast.showToast(msg: "Document updated successfully!");
        _medicine[localListIndex].name = medicine.name;
        return "Success";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return "Error";
    }
  }

  static Future updateBrandNamesArry(
      Medicine medicine, List? removedBrandNames, List<bool> operation) async {
    if (operation[0] == true) {
      await _medicineSubCollectionRef
          .doc(medicine.id)
          .update({"brand names": FieldValue.arrayUnion(medicine.brandNames)});
    } else if (operation[1] == true) {
      for (int i = 0; i < removedBrandNames!.length; i++) {
        await _medicineSubCollectionRef.doc(medicine.id).update({
          "brand names": FieldValue.arrayRemove([removedBrandNames[i]])
        });
      }
    } else {
      //Both
      await _medicineSubCollectionRef
          .doc(medicine.id)
          .update({"brand names": FieldValue.arrayUnion(medicine.brandNames)});

      for (int i = 0; i < removedBrandNames!.length; i++) {
        await _medicineSubCollectionRef.doc(medicine.id).update({
          "brand names": FieldValue.arrayRemove([removedBrandNames[i]])
        });
      }
    }
  }
}
