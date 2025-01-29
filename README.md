# AI Görsel Üretici

Yapay zeka tabanlı görsel üretim uygulaması, modern yazılım mimarisi prensipleri ve en güncel Flutter teknolojileri kullanılarak geliştirilmiştir.

## Teknoloji Yığını

### Gereksinimler
- Flutter SDK: 3.27.3 (stable channel)
- Dart SDK: 3.6.1
- Minimum Dart SDK: >=3.0.0 <4.0.0
- Android:
  - Compile SDK: Flutter default (34)
  - Min SDK: Flutter default (21)
  - Target SDK: Flutter default (34)
- iOS:
  - Deployment Target: iOS 11.0
  - Xcode: 14.0 veya üstü

### Temel Paketler
- **flutter_riverpod**: ^2.4.9
  - Bağımlılık enjeksiyonu ve state yönetimi için tercih edildi
  - Widget ağacından bağımsız state yönetimi sağlar
  - Test edilebilirliği artırır
  - Provider'lar arasında bağımlılık yönetimini kolaylaştırır

- **freezed**: ^2.4.6
  - İmmutable state yönetimi için kullanıldı
  - Union types ile hata yönetimini güçlendirir
  - Boilerplate kod yazımını minimize eder
  - Code generation ile type-safety sağlar

- **envied**: ^0.5.3
  - Güvenli environment variable yönetimi
  - API anahtarlarının güvenli saklanması
  - Build time'da environment değişkenlerinin derlenmesi

- **dio**: ^5.4.0
  - HTTP client
  - İnterceptor desteği
  - Form data ve multipart desteği

## Mimari

Uygulama, Clean Architecture prensiplerine uygun olarak katmanlı bir yapıda geliştirilmiştir. Bu yapı, kodun test edilebilirliğini, sürdürülebilirliğini ve ölçeklenebilirliğini artırır.

### Klasör Yapısı

```
lib/
├── core/                 # Temel altyapı kodları
│   ├── enums/           # Enum tanımlamaları
│   ├── error/           # Hata yönetimi
│   └── network/         # Ağ katmanı
├── features/            # Özellik modülleri
│   └── image_generation/
│       ├── data/        # Veri katmanı
│       │   ├── models/  # Data modelleri
│       │   └── repositories/
│       ├── domain/      # İş mantığı katmanı
│       │   └── repositories/
│       └── presentation/ # Sunum katmanı
│           ├── pages/   # Sayfa widget'ları
│           ├── providers/# State yönetimi
│           └── widgets/  # Yeniden kullanılabilir widget'lar
```

### Katmanlar

#### Core
- Uygulama genelinde kullanılan temel yapıları içerir
- Network istekleri için standart bir yapı sunar
- Hata yönetimi için özelleştirilmiş sınıflar barındırır

#### Data
- API entegrasyonları
- Model sınıfları
- Repository implementasyonları
- Local storage yönetimi

#### Domain
- Repository arayüzleri
- Business logic
- Entity sınıfları

#### Presentation
- UI bileşenleri
- State management
- Navigation logic

## State Yönetimi

Riverpod tercih edilmesinin sebepleri:
1. Dependency Injection yetenekleri
2. Auto-disposing mekanizması
3. Provider override özelliği ile kolay test yazımı
4. AsyncValue ile asenkron state yönetimi
5. Provider reference kontrolü ile memory leak önleme

### State Yapısı
```dart
@freezed
class ImageGenerationState with _$ImageGenerationState {
  const factory ImageGenerationState({
    required String prompt,
    required String imageUrl,
    required bool isLoading,
    required RequestStatus status,
    String? errorMessage,
  }) = _ImageGenerationState;
}
```

## Güvenlik

### Environment Variables
Uygulama, API anahtarlarını `.env` dosyasında saklar ve bu dosya version control sistemine eklenmez.

```env
# .env
OPENAI_API_KEY=your_api_key_here
DEEP_SEEK_API_KEY=your_api_key_here
STABLE_DIFFUSION_API_KEY=your_api_key_here
```

### API Güvenliği
- API anahtarları build time'da şifrelenir
- Network katmanında interceptor'lar ile güvenlik headerları eklenir
- SSL pinning implementasyonu

## Kurulum

1. Flutter SDK'yı yükleyin:
```bash
flutter --version
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Environment dosyasını oluşturun:
```bash
cp .env.example .env
```

4. Code generation'ı çalıştırın:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## API Entegrasyonları

### OpenAI DALL-E 3
- Maksimum görsel boyutu: 1024x1024
- Format: PNG
- Prompt optimizasyonu

### Stable Diffusion
- Model versiyonu: v2.1
- Sampling metodu: Euler a
- CFG scale: 7.5

### DeepSeek
- Model: DeepSeek-2.0
- Sampling steps: 30
- Negative prompt desteği

## Test Stratejisi

### Unit Tests
- Repository katmanı testleri
- Business logic testleri
- State management testleri

### Widget Tests
- UI bileşenlerinin test edilmesi
- State değişimlerinin doğrulanması

### Integration Tests
- End-to-end senaryoların test edilmesi
- API entegrasyonlarının doğrulanması

Mock data kullanımı:
```dart
final repository = ImageGenerationRepository(useMockData: true);
```

## Hata Yönetimi

- HTTP durum kodlarına göre özelleştirilmiş hata mesajları
- Kullanıcı dostu hata gösterimi
- Retry mekanizması
- Offline mod desteği

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.
