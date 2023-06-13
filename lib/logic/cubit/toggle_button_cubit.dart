import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'toggle_button_state.dart';

class ToggleButtonCubit extends Cubit<ToggleButtonState> with HydratedMixin {
  ToggleButtonCubit()
      : super(ToggleButtonState(
          toggleValue: false,
          intValue: 0,
        ));

  void onToggleButtonPress({bool value, int intValue}) {
    emit(state.copyWith(toggleValue: value, intValue: intValue + 1));
  }

  @override
  ToggleButtonState fromJson(Map<String, dynamic> json) {
    return ToggleButtonState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(ToggleButtonState state) {
    return state.toMap();
  }
}
