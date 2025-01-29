import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_generation_state.freezed.dart';

enum ImageTab {
  dallE,
  stableDiffusion,
  deepSeek
}

enum ImageSource {
  model,    // AI model tarafından üretilen
  mock,     // Test için kullanılan mock veri
  none      // Henüz görsel yok
}

enum RequestStatus {
  initial,
  loading,
  success,
  error,
  unauthorized,  // 401
  forbidden,     // 403
  notFound,      // 404
  serverError    // 500
}

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
