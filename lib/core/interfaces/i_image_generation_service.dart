abstract class IImageGenerationService {
  /// Verilen prompt'a göre görsel üretir
  Future<String> generateImage(String prompt);

  /// Servisin adını döndürür
  String get serviceName;

  /// Servisin API anahtarını döndürür
  String get apiKey;

  /// Servisin base URL'ini döndürür
  String get baseUrl;
} 