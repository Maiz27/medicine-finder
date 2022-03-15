import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine/models/pharmacyModel.dart';
import 'package:medicine/models/medicineModel.dart';
import 'package:jiffy/jiffy.dart';

class QueryService {
  final rootRef = FirebaseFirestore.instance;
  static List<Pharmacy> pharmacies = [];
  static List<Medicine> _results = [];
  static List<FinalSearchResult> finalSearchResult = [];
  static List<PopularMedicine> _popular = [];
  static List<PopularMedicine> _finalpopular = [];

  //Getters for pharmacies & search SearchResults
  List<FinalSearchResult> getResults() {
    return finalSearchResult;
  }

  List<Pharmacy> getPharmacy() {
    return pharmacies;
  }

  List<PopularMedicine> getPopular() {
    return _finalpopular;
  }

// Get the list of pharmacies using the app
  Future getPharmaciesFromFirestore() async {
    var query = (await rootRef.collection("Pharmacies").get());

    //Convert query result to a list to loop through them
    List results = query.docs.map((e) => e.data()).toList();

    //First check if the list is empty or not before converting
    //results to dart models
    if (query.size > 0) {
      if (pharmacies.isNotEmpty) {
        pharmacies.clear();
      }
      results.forEach((element) {
        //Convert list of results to model dart models
        Pharmacy r = Pharmacy.fromJson(element);
        pharmacies.add(r);
      });
      return "Success";
    }
    return "Error";
  }

  //search for medicine by scientific name
  Future genericSearch(String name) async {
    var query = (await rootRef
        .collectionGroup("medicine")
        .where("generic name", isEqualTo: name.toLowerCase())
        .where("inStock", isEqualTo: true)
        .get());

    if (query.size > 0) {
      //Convert query result to a list to loop through them
      List results = query.docs.map((e) => e.data()).toList();
      //First check if the list is empty or not before converting
      //results to dart models
      if (_results.isNotEmpty) {
        _results.clear();
      }
      results.forEach((element) {
        //Convert list of results to model dart models
        Medicine r = Medicine.fromJson(element);
        _results.add(r);
      });
      combineMedicineList();
      return "Success";
    } else {
      return "Failure";
    }
  }

  // search for medicine by brand names
  Future brandSearch(String name) async {
    var query = (await rootRef
        .collectionGroup("medicine")
        .where("brandList", arrayContains: name.toLowerCase())
        .where("inStock", isEqualTo: true)
        .get());

    if (query.size > 0) {
      //Convert query result to a list to loop through them
      List results = query.docs.map((e) => e.data()).toList();
      //First check if the list is empty or not before converting
      //results to dart models
      if (_results.isNotEmpty) {
        _results.clear();
      }
      results.forEach((element) {
        //Convert list of results to model dart models
        Medicine r = Medicine.fromJson(element);
        _results.add(r);
      });
      combineMedicineList();
      return "Success";
    } else {
      return "Failure";
    }
  }

  //Method to combineMedicineList the two lists into one Final Search results lists
  void combineMedicineList() {
    if (finalSearchResult.isNotEmpty) {
      finalSearchResult.clear();
    }
    pharmacies.forEach((element) {
      _results.forEach((e) {
        if (e.pharmacyId == element.id) {
//To avoid taking the complete list of brand names for all the pharmacies in
//every instance, first find the index of the currently iterated element from
//result then use it as an index to access each pharmacy's brand names separately
          finalSearchResult.add(FinalSearchResult(
            element.name,
            element.tele,
            element.lat,
            element.lng,
            e.name.toString(),
            e.brandNames,
            e.desc,
          ));
        }
      });
    });
  }

  //Querying Popular medicine base on dates
  Future popularBasedOnDate(int timeFrame) async {
    var t = DateTime.now();
    var date;

    switch (timeFrame) {
      case 1:
        date = Jiffy().subtract(days: 7).dateTime;
        break;
      case 2:
        var days = t.day;
        date = Jiffy().subtract(days: days).dateTime;
        break;
      case 3:
        date = Jiffy().subtract(months: 3).dateTime;
        break;
      case 4:
        date = Jiffy().subtract(months: 6).dateTime;
        break;
      case 5:
        date = Jiffy().subtract(months: 12).dateTime;
        break;
      default:
        return "No Time Frame specified";
    }

    var query = (await rootRef
        .collectionGroup("dates")
        .where("date", isGreaterThan: date)
        .get());

    if (query.size > 0) {
      //Convert query result to a list to loop through them
      List results = query.docs.map((e) => e.data()).toList();
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
      combinePopular();
      return "Success";
    } else {
      return "Failure";
    }
  }

  void combinePopular() {
    if (_finalpopular.isNotEmpty) {
      _finalpopular.clear();
    }

    for (int i = 0; i < _popular.length; i++) {
      var x = _popular.where((element) => element.name == _popular[i].name);

      if (_finalpopular.any((element) => element.name == _popular[i].name)) {
        continue;
      }
      PopularMedicine m = new PopularMedicine(name: "", count: 0);
      x.forEach((value) {
        m.name = value.name;
        m.count = m.count + value.count;
      });
      _finalpopular.add(m);
    }
    // To sort the list in descending order
    // if the sort func receive 1 it means the 1st item < 2nd item
    // So make it receive -1 to get a list in descending order (1st > 2nd)
    _finalpopular.sort((a, b) => a.count >= b.count ? -1 : 1);
  }
}
