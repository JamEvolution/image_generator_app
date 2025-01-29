import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/generation_status.dart';
import '../../../../core/enums/image_service_type.dart';
import '../../data/repositories/image_generation_repository.dart';
import '../../domain/entities/image_state.dart';
import '../../domain/repositories/i_image_generation_repository.dart';

final imageGenerationRepositoryProvider = Provider<IImageGenerationRepository>(
  (ref) => ImageGenerationRepository(),
);

final selectedServiceProvider = StateProvider<ImageServiceType>(
  (ref) => ImageServiceType.deepSeek,
);

final imageGenerationStateProvider = StateNotifierProvider<ImageGenerationNotifier, ImageState>(
  (ref) => ImageGenerationNotifier(
    repository: ref.watch(imageGenerationRepositoryProvider),
    ref: ref,
  ),
);

class ImageGenerationNotifier extends StateNotifier<ImageState> {
  final IImageGenerationRepository _repository;
  final Ref _ref;

  ImageGenerationNotifier({
    required IImageGenerationRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const ImageState());

  Future<void> generateImage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    state = state.copyWith(
      status: GenerationStatus.loading,
      prompt: prompt,
    );

    try {
      final selectedService = _ref.read(selectedServiceProvider);
      final imageUrl = await _repository.generateImage(
        prompt: prompt,
        serviceType: selectedService,
      );

      state = state.copyWith(
        status: GenerationStatus.success,
        imageUrl: imageUrl,
      );
    } catch (e) {
      state = state.copyWith(
        status: GenerationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
} 