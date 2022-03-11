// ignore_for_file: non_constant_identifier_names

class Medicine {
  String pharmacyId;
  String id;
  String name;
  List brandNames;
  List brandList;
  bool inStock;

  Medicine(
      {required this.pharmacyId,
      required this.name,
      required this.brandNames,
      required this.id,
      required this.inStock,
      required this.brandList});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      pharmacyId: json['pharmacyId'],
      name: json['generic name'],
      id: json['id'],
      inStock: json['inStock'],
      brandList: json['brandList'],
      brandNames: fromJsonArr(json['brand names']),
    );
  }
}

// Brand names are in a nested array
//must loop through to access them
List fromJsonArr(List<dynamic> jsonArray) {
  List brandNames = [];
  jsonArray.forEach((element) {
    brandNames.add(element);
  });
  return brandNames;
}

class FinalSearchResult {
  String pharmacyName;
  String tele;
  double lat;
  double lng;
  String medicine;
  List brandNames;

  FinalSearchResult(this.pharmacyName, this.tele, this.lat, this.lng,
      this.medicine, this.brandNames);
}

class PopularMedicine {
  String name;
  int count;

  PopularMedicine({required this.name, required this.count});

  factory PopularMedicine.fromJson(Map<dynamic, dynamic> json) {
    return PopularMedicine(
      name: json['medicine name'],
      count: json['search counter'],
    );
  }
}
