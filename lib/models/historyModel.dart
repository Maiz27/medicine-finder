import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  String? id;
  String? name;
  String? searchedBy;
  Timestamp? searchedOn;

  SearchHistory(
      {required this.name,
      required this.searchedBy,
      required this.searchedOn,
      required this.id});

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'],
      name: json['name'],
      searchedBy: json['searchedBy'],
      searchedOn: json['searchedOn'],
    );
  }
}
