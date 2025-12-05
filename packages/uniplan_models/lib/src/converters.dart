import 'package:freezed_annotation/freezed_annotation.dart';

DateTime? dateTimeFromJson(Object? input) {
  if (input == null) return null;
  if (input is DateTime) return input;
  return DateTime.parse(input.toString());
}

String? dateTimeToJson(DateTime? value) => value?.toIso8601String();

@internal
Set<int> intSetFromJson(List<dynamic>? raw) {
  if (raw == null) return <int>{};
  return raw.where((e) => e != null).map((e) => (e as num).toInt()).toSet();
}

@internal
List<int> intSetToJson(Set<int> values) => values.toList();
