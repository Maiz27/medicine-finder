// ignore_for_file: non_constant_identifier_names

class Medicine {
  String pharmacyId;
  String id;
  String name;
  int price;
  List brandNames;
  bool inStock;

  Medicine({
    required this.pharmacyId,
    required this.name,
    required this.price,
    required this.brandNames,
    required this.id,
    required this.inStock,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      pharmacyId: json['pharmacyId'],
      name: json['generic name'],
      price: json['price'],
      id: json['id'],
      inStock: json['inStock'],
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
  String price;
  List brandNames;

  FinalSearchResult(this.pharmacyName, this.tele, this.lat, this.lng,
      this.medicine, this.price, this.brandNames);
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
