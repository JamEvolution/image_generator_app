enum ImageServiceType {
  deepSeek,
  stableDiffusion,
  dallE;

  String get displayName {
    switch (this) {
      case ImageServiceType.deepSeek:
        return 'Deep Seek';
      case ImageServiceType.stableDiffusion:
        return 'Stable Diffusion';
      case ImageServiceType.dallE:
        return 'DALL-E';
    }
  }

  String get baseUrl {
    switch (this) {
      case ImageServiceType.deepSeek:
        return 'https://api.deepseek.com';
      case ImageServiceType.stableDiffusion:
        return 'https://api.stability.ai';
      case ImageServiceType.dallE:
        return 'https://api.openai.com';
    }
  }

  String get endpoint {
    switch (this) {
      case ImageServiceType.deepSeek:
      case ImageServiceType.dallE:
        return '/v1/images/generations';
      case ImageServiceType.stableDiffusion:
        return '/v1/text-to-image';
    }
  }
} 