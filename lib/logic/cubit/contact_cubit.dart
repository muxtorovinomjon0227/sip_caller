import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:meta/meta.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());

  void contactLoad(Iterable<Contact> contactList) {
    emit(ContactLoaded(contactService: contactList));
  }
}
