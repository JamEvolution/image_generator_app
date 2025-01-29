import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/generation_status.dart';

part 'image_state.freezed.dart';

@freezed
class ImageState with _$ImageState {
  const factory ImageState({
    @Default('') String prompt,
    @Default('') String imageUrl,
    @Default(GenerationStatus.initial) GenerationStatus status,
    String? errorMessage,
  }) = _ImageState;
} 