// ignore_for_file: non_constant_identifier_names

class Pharmacy {
  String name;
  String tele;
  double lat;
  double lng;

  Pharmacy(
      {required this.name,
      required this.tele,
      required this.lat,
      required this.lng});

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
        name: json['Pharmacy name'],
        tele: json['telephone'],
        lat: json['Lat'],
        lng: json['Lng']);
  }
}
