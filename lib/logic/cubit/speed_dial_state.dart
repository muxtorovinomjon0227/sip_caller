part of 'speed_dial_cubit.dart';

class SpeedDialState {
  List<SpeedDialModel> speedDialList;

  SpeedDialState({
    @required this.speedDialList,
  });

  Map<String, dynamic> toMap() {
    return {
      'speedDialList': speedDialList?.map((x) => x.toMap())?.toList(),
    };
  }

  factory SpeedDialState.fromMap(Map<String, dynamic> map) {
    return SpeedDialState(
      speedDialList: List<SpeedDialModel>.from(
          map['speedDialList']?.map((x) => SpeedDialModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SpeedDialState.fromJson(String source) =>
      SpeedDialState.fromMap(json.decode(source));
}
