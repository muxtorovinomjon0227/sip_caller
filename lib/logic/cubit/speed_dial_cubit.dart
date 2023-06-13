import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kothon_app/data/models/speed_dial_model.dart';
import 'package:meta/meta.dart';

part 'speed_dial_state.dart';

class SpeedDialCubit extends Cubit<SpeedDialState> with HydratedMixin {
  SpeedDialCubit() : super(SpeedDialState(speedDialList: []));

  void addSpeedDial(SpeedDialModel speedDialModel) {
    state.speedDialList.add(speedDialModel);
    emit(SpeedDialState(speedDialList: state.speedDialList));
  }

  void delSpeedDial(int index) {
    state.speedDialList.removeAt(index);
    emit(SpeedDialState(speedDialList: state.speedDialList));
  }

  @override
  SpeedDialState fromJson(Map<String, dynamic> json) {
    return SpeedDialState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(SpeedDialState state) {
    return state.toMap();
  }
}
