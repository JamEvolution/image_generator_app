import '../enums/image_service_type.dart';
import '../env/env.dart';
import 'base_client.dart';

class ImageGenerationClient extends BaseClient {
  final ImageServiceType serviceType;

  ImageGenerationClient({required this.serviceType})
      : super(
          baseUrl: serviceType.baseUrl,
          apiKey: _getApiKey(serviceType),
        );

  static String _getApiKey(ImageServiceType serviceType) {
    switch (serviceType) {
      case ImageServiceType.deepSeek:
        return Env.deepSeekApiKey;
      case ImageServiceType.stableDiffusion:
        return Env.stableDiffusionApiKey;
      case ImageServiceType.dallE:
        return Env.dallEApiKey;
    }
  }

  Future<Map<String, dynamic>> generateImage(String prompt) async {
    final requestData = _createRequestData(prompt);
    return post<Map<String, dynamic>>(
      serviceType.endpoint,
      data: requestData,
    );
  }

  Map<String, dynamic> _createRequestData(String prompt) {
    final baseData = {
            'prompt': prompt,
            'n': 1,
            'size': '1024x1024',
    };

    switch (serviceType) {
      case ImageServiceType.deepSeek:
        return baseData;
      case ImageServiceType.stableDiffusion:
        return {
          ...baseData,
          'samples': baseData['n'],
            'width': 1024,
            'height': 1024,
        }..remove('n')..remove('size');
      case ImageServiceType.dallE:
        return {
          ...baseData,
          'response_format': 'url',
      };
    }
  }

  String extractImageUrl(Map<String, dynamic> responseData) {
    switch (serviceType) {
      case ImageServiceType.deepSeek:
      case ImageServiceType.dallE:
        return responseData['data'][0]['url'] as String;
      case ImageServiceType.stableDiffusion:
        return responseData['output'][0] as String;
    }
  }
} 