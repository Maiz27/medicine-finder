import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine/models/pharmacyModel.dart';
import 'package:medicine/models/searchResultModel.dart';

class QueryService {
  final rootRef = FirebaseFirestore.instance;
  List<Pharmacy> _pharmacies = [];
  List<Results> _results = [];

  //Getters for pharmacies & search results
  List<Results> getResults() {
    return _results;
  }

  List<Pharmacy> getPharmacy() {
    return _pharmacies;
  }

// Get the list of pharmacies using the app
  Future getPharmaciesFromFirestore() async {
    var query = (await rootRef.collectionGroup("Pharmacies").get());

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
  Future scientificSearch(String name) async {
    var query = (await rootRef
        .collectionGroup("medicine")
        .where("name", isEqualTo: name)
        .where("inStock", isEqualTo: true)
        .get());

    //Convert query result to a list to loop through them
    List results = query.docs.map((e) => e.data()).toList();

    //First check if the list is empty or not before converting
    //results to dart models
    if (_results.isNotEmpty) {
      _results.clear();
    }
    results.forEach((element) {
      //Convert list of results to model dart models
      Results r = Results.fromJson(element);
      _results.add(r);
    });
  }
}
