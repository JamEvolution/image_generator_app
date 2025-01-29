import '../../../../core/enums/image_service_type.dart';
import '../../../../core/error/network_error.dart';
import '../../../../core/network/dalle_client.dart';
import '../models/dalle_request.dart';
import '../../domain/repositories/i_image_generation_repository.dart';

class ImageGenerationRepository implements IImageGenerationRepository {
  final DalleClient _dalleClient;
  final bool useMockData;

  ImageGenerationRepository({this.useMockData = false}) : _dalleClient = DalleClient();

  @override
  Future<String> generateImage({
    required String prompt,
    required ImageServiceType serviceType,
  }) async {
    if (useMockData) {
      // Geliştirme aşamasında mock data kullan
      await Future.delayed(const Duration(seconds: 2)); // Gerçekçi gecikme
      return _getMockImageUrl(prompt);
    }

    try {
      switch (serviceType) {
        case ImageServiceType.dallE:
          final request = DalleRequest(prompt: prompt);
          final response = await _dalleClient.generateImage(request);
          return response.data.first.url;
        
        default:
          return _getMockImageUrl(prompt);
      }
    } on NetworkError catch (e) {
      if (e.message.contains('billing_hard_limit_reached')) {
        throw NetworkError(
          message: 'OpenAI hesabınızın kullanım limiti dolmuş. Lütfen ödeme ayarlarınızı kontrol edin.',
          statusCode: e.statusCode,
        );
      }
      print('Hata oluştu: ${e.message} (${e.statusCode})');
      return _getMockImageUrl(prompt);
    }
  }

  String _getMockImageUrl(String prompt) {
    // Farklı mock resimler için prompt'u kullanabilirsiniz
    final mockImages = [
      'https://picsum.photos/400/400',
      'https://picsum.photos/500/500',
      'https://picsum.photos/600/600',
    ];
    
    // Prompt'un hash'ine göre farklı resimler dön
    final index = prompt.hashCode % mockImages.length;
    return mockImages[index];
  }
} 