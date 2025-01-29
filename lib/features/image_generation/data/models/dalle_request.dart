import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dalle_request.freezed.dart';
part 'dalle_request.g.dart';

@freezed
class DalleRequest with _$DalleRequest {
  const factory DalleRequest({
    required String prompt,
    @Default('dall-e-3') String model,
    @Default(1) int n,
    @Default('standard') String quality,
    @JsonKey(name: 'response_format') @Default('url') String responseFormat,
    @Default('1024x1024') String size,
    @Default('vivid') String style,
  }) = _DalleRequest;

  factory DalleRequest.fromJson(Map<String, dynamic> json) =>
      _$DalleRequestFromJson(json);
} 