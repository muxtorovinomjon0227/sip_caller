import 'dart:convert';

class HistoryModel {
  final String name;
  final String contact;
  final String timeStamp;

  HistoryModel(this.name, this.contact, this.timeStamp);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'timeStamp': timeStamp,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      map['name'],
      map['contact'],
      map['timeStamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) =>
      HistoryModel.fromMap(json.decode(source));
}
