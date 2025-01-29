import '../../../../core/enums/image_service_type.dart';

abstract class IImageGenerationRepository {
  /// Verilen prompt ve servis tipine göre görsel üretir
  Future<String> generateImage({
    required String prompt,
    required ImageServiceType serviceType,
  });
} 