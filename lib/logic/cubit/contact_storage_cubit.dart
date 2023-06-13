import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kothon_app/data/models/contact_model.dart';
import 'package:meta/meta.dart';

part 'contact_storage_state.dart';

class ContactStorageCubit extends Cubit<ContactStorageState>
    with HydratedMixin {
  ContactStorageCubit() : super(ContactStorageState(contactModelList: []));

  void addContact(ContactModel contactModel) {
    state.contactModelList.add(contactModel);
    emit(ContactStorageState(contactModelList: state.contactModelList));
  }

  void removeAllContacts() {
    state.contactModelList.clear();
    emit(ContactStorageState(contactModelList: state.contactModelList));
  }

  @override
  ContactStorageState fromJson(Map<String, dynamic> json) {
    return ContactStorageState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(ContactStorageState state) {
    return state.toMap();
  }
}
