// ignore_for_file: non_constant_identifier_names

class Results {
  String? Pname;

  String? Mname;
  int? price;

  Results({this.Pname, this.Mname, this.price});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
        Pname: json['PharmacyID'], Mname: json['name'], price: json['price']);
  }
}
