import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  const LoginField({
    @required this.serverUriController,
    @required this.header,
    @required this.hintText,
    Key key,
  }) : super(key: key);

  final TextEditingController serverUriController;
  final String header;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Text(
              header,
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 15,
            // color: Colors.white,
            child: TextField(
              textAlign: TextAlign.center,
              controller: serverUriController,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.only(
                  bottom: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
