import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kothon_app/data/models/history_model.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> with HydratedMixin {
  HistoryCubit() : super(HistoryState(historyList: []));

  void addHistory(HistoryModel historyModel) {
    state.historyList.add(historyModel);
    emit(HistoryState(historyList: state.historyList));
  }

  void delHistory(int index) {
    state.historyList.removeAt(index);
    emit(HistoryState(historyList: state.historyList));
  }

  void clearHistory() {
    state.historyList.clear();
    emit(HistoryState(historyList: state.historyList));
  }

  @override
  HistoryState fromJson(Map<String, dynamic> json) {
    return HistoryState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(HistoryState state) {
    return state.toMap();
  }
}
