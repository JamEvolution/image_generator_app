import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/enums/image_source.dart';
import '../../domain/enums/image_tab.dart';
import '../../domain/enums/request_status.dart';

part 'image_generation_state.freezed.dart';

@freezed
class ImageGenerationState with _$ImageGenerationState {
  const factory ImageGenerationState({
    @Default('') String prompt,
    @Default('') String imageUrl,
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(ImageTab.dallE) ImageTab selectedTab,
    @Default([]) List<String> generatedImages,
    @Default(RequestStatus.initial) RequestStatus status,
    @Default(null) int? statusCode,
    @Default(ImageSource.none) ImageSource imageSource,
  }) = _ImageGenerationState;
} 
