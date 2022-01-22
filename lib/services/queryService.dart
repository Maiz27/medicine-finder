import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine/models/pharmacyModel.dart';
import 'package:medicine/models/searchResultModel.dart';

class QueryService {
  final rootRef = FirebaseFirestore.instance;
  List<Pharmacy> _pharmacies = [];
  List<Medicine> _results = [];
  List<FinalSearchResult> _finalSearchResult = [];

  //Getters for pharmacies & search SearchResults
  List<FinalSearchResult> getResults() {
    return _finalSearchResult;
  }

  List<Pharmacy> getPharmacy() {
    return _pharmacies;
  }

// Get the list of pharmacies using the app
  Future getPharmaciesFromFirestore() async {
    var query = (await rootRef.collection("Pharmacies").get());

    //Convert query result to a list to loop through them
    List results = query.docs.map((e) => e.data()).toList();

    //First check if the list is empty or not before converting
    //results to dart models
    if (_pharmacies.isNotEmpty) {
      _pharmacies.clear();
    }
    results.forEach((element) {
      //Convert list of results to model dart models
      Pharmacy r = Pharmacy.fromJson(element);
      _pharmacies.add(r);
    });
  }

  //search for medicine by scientific name
  Future genericSearch(String name) async {
    var query = (await rootRef
        .collectionGroup("medicine")
        .where("generic name", isEqualTo: name)
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
      combine();
      return "Success";
    } else {
      return "Failure";
    }
  }

  // search for medicine by brand names
  Future brandSearch(String name) async {
    var query = (await rootRef
        .collectionGroup("medicine")
        .where("brand names", arrayContains: name)
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
      combine();
      return "Success";
    } else {
      return "Failure";
    }
  }

  //Method to combine the two lists into one Final Search results lists
  void combine() {
    if (_finalSearchResult.isNotEmpty) {
      _finalSearchResult.clear();
    }
    _pharmacies.forEach((element) {
      _results.forEach((e) {
        if (e.Pname == element.name) {
//To avoid taking the complete list of brand names for all the pharmacies in
//every instance, first find the index of the currently iterated element from
//result then use it as an index to access each pharmacy's brand names separately
          int x = _results.indexOf(e);
          _finalSearchResult.add(FinalSearchResult(
            element.name,
            element.tele,
            element.lat,
            element.lng,
            e.Mname.toString(),
            e.price.toString(),
            e.brandNames[x],
          ));
        }
      });
    });
  }
}
