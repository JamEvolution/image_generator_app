import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/i_image_generation_repository.dart';
import '../../data/repositories/image_generation_repository.dart';

final imageGenerationRepositoryProvider = Provider<IImageGenerationRepository>((ref) {
  return ImageGenerationRepository(useMockData: true); // Geliştirme için mock data kullan
}); 