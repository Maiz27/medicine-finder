// ignore_for_file: non_constant_identifier_names

class SearchResults {
  String? Pname;

  String? Mname;
  int? price;

  SearchResults({this.Pname, this.Mname, this.price});

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
        Pname: json['PharmacyID'], Mname: json['name'], price: json['price']);
  }
}

class FinalResult {
  String pharmacyName;
  String tele;
  double lat;
  double lng;
  String medicine;
  String price;

  FinalResult(this.pharmacyName, this.tele, this.lat, this.lng, this.medicine,
      this.price);
}
