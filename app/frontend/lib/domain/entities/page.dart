import 'package:freezed_annotation/freezed_annotation.dart';

part 'page.freezed.dart';
part 'page.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PageEnvelope<T> with _$PageEnvelope<T> {
  const factory PageEnvelope({
    required List<T> content,
    required int totalElements,
    required int totalPages,
    required int size,
    required int number,
  }) = _PageEnvelope<T>;

  factory PageEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PageEnvelopeFromJson(json, fromJsonT);
}
