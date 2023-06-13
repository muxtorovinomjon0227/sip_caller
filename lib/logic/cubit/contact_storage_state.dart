part of 'contact_storage_cubit.dart';

class ContactStorageState {
  List<ContactModel> contactModelList;

  ContactStorageState({
    @required this.contactModelList,
  });

  Map<String, dynamic> toMap() {
    return {
      'contactModelList': contactModelList?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ContactStorageState.fromMap(Map<String, dynamic> map) {
    return ContactStorageState(
      contactModelList: List<ContactModel>.from(
          map['contactModelList']?.map((x) => ContactModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactStorageState.fromJson(String source) =>
      ContactStorageState.fromMap(json.decode(source));
}
