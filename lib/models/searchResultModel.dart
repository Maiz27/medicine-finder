// ignore_for_file: non_constant_identifier_names

class SearchResults {
  String? Pname;

  String? Mname;
  int? price;
  List brandNames;

  SearchResults(
      {required this.Pname,
      required this.Mname,
      required this.price,
      required this.brandNames});

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      Pname: json['PharmacyID'],
      Mname: json['generic name'],
      price: json['price'],
      brandNames: fromJsonArr(json['brand names']),
    );
  }
}

// Brand names are in a nested array
//must loop through to access them
List fromJsonArr(List<dynamic> jsonArray) {
  List brandNames = [];
  jsonArray.forEach((element) {
    brandNames.add(jsonArray);
  });
  return brandNames;
}

class FinalResult {
  String pharmacyName;
  String tele;
  double lat;
  double lng;
  String medicine;
  String price;
  List brandNames;

  FinalResult(this.pharmacyName, this.tele, this.lat, this.lng, this.medicine,
      this.price, this.brandNames);
}
