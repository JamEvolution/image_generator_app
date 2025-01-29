import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dalle_response.freezed.dart';
part 'dalle_response.g.dart';

@freezed
class DalleResponse with _$DalleResponse {
  const factory DalleResponse({
    required int created,
    required List<DalleImage> data,
  }) = _DalleResponse;

  factory DalleResponse.fromJson(Map<String, dynamic> json) =>
      _$DalleResponseFromJson(json);
}

@freezed
class DalleImage with _$DalleImage {
  const factory DalleImage({
    required String url,
    @JsonKey(name: 'b64_json') String? b64Json,
    @JsonKey(name: 'revised_prompt') String? revisedPrompt,
  }) = _DalleImage;

  factory DalleImage.fromJson(Map<String, dynamic> json) =>
      _$DalleImageFromJson(json);
} 