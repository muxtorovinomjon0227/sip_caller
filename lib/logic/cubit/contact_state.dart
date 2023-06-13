part of 'contact_cubit.dart';

@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoaded extends ContactState {
  final Iterable<Contact> contactService;

  ContactLoaded({@required this.contactService});
}
