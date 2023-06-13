part of 'toggle_button_cubit.dart';

class ToggleButtonState {
  final bool toggleValue;
  final int intValue;
  ToggleButtonState({
    @required this.toggleValue,
    @required this.intValue,
  });

  ToggleButtonState copyWith({
    bool toggleValue,
    int intValue,
  }) {
    return ToggleButtonState(
      toggleValue: toggleValue ?? this.toggleValue,
      intValue: intValue ?? this.intValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toggleValue': toggleValue,
      'intValue': intValue,
    };
  }

  factory ToggleButtonState.fromMap(Map<String, dynamic> map) {
    return ToggleButtonState(
      toggleValue: map['toggleValue'],
      intValue: map['intValue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ToggleButtonState.fromJson(String source) =>
      ToggleButtonState.fromMap(json.decode(source));
}
