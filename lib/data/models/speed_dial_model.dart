import 'dart:convert';

class SpeedDialModel {
  String name;
  String contact;

  SpeedDialModel({this.name, this.contact});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
    };
  }

  factory SpeedDialModel.fromMap(Map<String, dynamic> map) {
    return SpeedDialModel(
      name: map['name'],
      contact: map['contact'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SpeedDialModel.fromJson(String source) =>
      SpeedDialModel.fromMap(json.decode(source));
}
