import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kothon_app/data/models/contact_model.dart';
import 'package:kothon_app/logic/cubit/contact_cubit.dart';
import 'package:kothon_app/logic/cubit/contact_storage_cubit.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<ContactModel> _contactModelList;

  Future<void> getContacts() async {
    // Make sure we already have permissions for contacts when we get to
    // this page. Then we retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    // setState(() {
    //   _contacts = contacts;
    // });
    context.read<ContactCubit>().contactLoad(contacts);

    context.read<ContactStorageCubit>().removeAllContacts();

    // testing purpose

    for (int i = 0; i < contacts.length; i++) {
      context.read<ContactStorageCubit>().addContact(ContactModel(
          contacts.elementAt(i).displayName,
          contacts
              .elementAt(i)
              .phones
              .firstWhere((element) => element != null)
              .value));
    }
  }

  @override
  Widget build(BuildContext context) {
    _contactModelList =
        context.watch<ContactStorageCubit>().state.contactModelList;

    return Scaffold(
      appBar: AppBar(
        title: Text("CONTACTS TEST PAGE"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await getContacts();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _contactModelList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_contactModelList[index].displayName),
            subtitle: Text(_contactModelList[index].contactNo),
          );
        },
      ),
    );
  }
}
