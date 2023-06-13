import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/data/models/speed_dial_model.dart';
import 'package:kothon_app/logic/cubit/speed_dial_cubit.dart';

Future speedDialAddDialog({
  BuildContext context,
  TextEditingController nameController,
  TextEditingController contactController,
}) {
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        // final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  elevation: 10,
                  backgroundColor: KothonColors.navBarColor.withOpacity(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  insetAnimationCurve: Curves.easeInOutCirc,
                  insetAnimationDuration: Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: KothonColors.dialPadHeaderColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Add Speed Dial',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        //======================= TEXT FIELD FOR NAME ===============================//
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: nameController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Name',
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        //======================= TEXT FIELD FOR CONTACT NO ===============================//

                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: contactController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Contact No',
                            ),
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Add +',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: KothonColors.greenBtn,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(context, [
                                nameController.text,
                                contactController.text
                              ]);

                              if (nameController.text != null &&
                                  nameController.text != '' &&
                                  contactController.text != null &&
                                  contactController.text != '') {
                                context
                                    .read<SpeedDialCubit>()
                                    .addSpeedDial(SpeedDialModel(
                                      name: nameController.text,
                                      contact: contactController.text,
                                    ));
                              } else {
                                return;
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return;
      });
}
