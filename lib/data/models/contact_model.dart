import 'dart:convert';

class ContactModel {
  final String displayName;
  final String contactNo;

  ContactModel(this.displayName, this.contactNo);

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'contactNo': contactNo,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      map['displayName'],
      map['contactNo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source));
}
