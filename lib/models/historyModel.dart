import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  String? name;
  String? searchedBy;
  Timestamp? searchedOn;

  SearchHistory({
    required this.name,
    required this.searchedBy,
    required this.searchedOn,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      name: json['name'],
      searchedBy: json['searchedBy'],
      searchedOn: json['searchedOn'],
    );
  }
}
