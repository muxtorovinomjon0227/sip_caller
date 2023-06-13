part of 'history_cubit.dart';

class HistoryState {
  List<HistoryModel> historyList;

  HistoryState({
    @required this.historyList,
  });

  Map<String, dynamic> toMap() {
    return {
      'historyList': historyList?.map((x) => x.toMap())?.toList(),
    };
  }

  factory HistoryState.fromMap(Map<String, dynamic> map) {
    return HistoryState(
      historyList: List<HistoryModel>.from(
          map['historyList']?.map((x) => HistoryModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryState.fromJson(String source) =>
      HistoryState.fromMap(json.decode(source));
}
