import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/image_service_type.dart';
import '../../../../core/error/network_error.dart';
import '../../domain/enums/image_source.dart';
import '../../domain/enums/image_tab.dart';
import '../../domain/enums/request_status.dart';
import '../../domain/repositories/i_image_generation_repository.dart';
import 'image_generation_state.dart';
import '../../data/repositories/image_generation_repository.dart';
import 'package:flutter/rendering.dart';

// Repository provider'ı tanımlıyoruz
final imageGenerationRepositoryProvider = Provider<IImageGenerationRepository>((ref) {
  return ImageGenerationRepository(useMockData: false);
});

final imageGenerationNotifierProvider =
    NotifierProvider<ImageGenerationNotifier, ImageGenerationState>(
  () => ImageGenerationNotifier(),
);

class ImageGenerationNotifier extends Notifier<ImageGenerationState> {
  late final IImageGenerationRepository _repository;

  @override
  ImageGenerationState build() {
    _repository = ref.watch(imageGenerationRepositoryProvider);
    return const ImageGenerationState();
  }

  void updatePrompt(String value) {
    state = state.copyWith(prompt: value);
  }

  void changeTab(ImageTab tab) {
    if (state.selectedTab != tab) {
      state = state.copyWith(
        selectedTab: tab,
        imageUrl: '', // Sekme değiştiğinde görseli temizle
        errorMessage: null, // Hata mesajını temizle
        status: RequestStatus.initial, // Status'u sıfırla
        statusCode: null, // Status code'u sıfırla
      );
    }
  }

  void clearCurrentImage() {
    state = state.copyWith(
      imageUrl: '',
      status: RequestStatus.initial,
      statusCode: null,
      imageSource: ImageSource.none,
    );
  }

  void addToGeneratedImages(String imageUrl) {
    state = state.copyWith(
      generatedImages: [...state.generatedImages, imageUrl],
    );
  }

  RequestStatus _getRequestStatus(int statusCode) {
    switch (statusCode) {
      case 200:
        return RequestStatus.success;
      case 401:
        return RequestStatus.unauthorized;
      case 403:
        return RequestStatus.forbidden;
      case 404:
        return RequestStatus.notFound;
      case >= 500:
        return RequestStatus.serverError;
      default:
        return RequestStatus.error;
    }
  }

  String _getErrorMessage(RequestStatus status) {
    switch (status) {
      case RequestStatus.unauthorized:
        return 'API anahtarınız geçersiz veya eksik';
      case RequestStatus.forbidden:
        return 'Bu işlem için yetkiniz yok';
      case RequestStatus.notFound:
        return 'İstek yapılan kaynak bulunamadı';
      case RequestStatus.serverError:
        return 'Sunucu hatası oluştu, lütfen daha sonra tekrar deneyin';
      default:
        return 'Bir hata oluştu, lütfen tekrar deneyin';
    }
  }

  String _getMockImageUrl(String prompt) {
    final mockImages = [
      'https://picsum.photos/400/400',
      'https://picsum.photos/500/500',
      'https://picsum.photos/600/600',
    ];
    final index = prompt.hashCode % mockImages.length;
    return mockImages[index];
  }

  Future<void> generateImage() async {
    if (state.prompt.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Lütfen bir metin girin',
        status: RequestStatus.error,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      status: RequestStatus.loading,
      statusCode: null,
      imageSource: ImageSource.none,
    );

    try {
      if (_repository is ImageGenerationRepository && (_repository as ImageGenerationRepository).useMockData) {
        // Mock data kullanılıyorsa
        await Future.delayed(const Duration(seconds: 2)); // Gerçekçi gecikme
        final mockUrl = _getMockImageUrl(state.prompt);
        state = state.copyWith(
          imageUrl: mockUrl,
          isLoading: false,
          status: RequestStatus.success,
          statusCode: 200,
          imageSource: ImageSource.mock,
        );
        addToGeneratedImages(mockUrl);
        return;
      }

      final imageUrl = await _repository.generateImage(
        prompt: state.prompt,
        serviceType: _getServiceType(),
      );

      state = state.copyWith(
        imageUrl: imageUrl,
        isLoading: false,
        status: RequestStatus.success,
        statusCode: 200,
        imageSource: ImageSource.model,
      );
      
      addToGeneratedImages(imageUrl);
    } on NetworkError catch (e) {
      final status = _getRequestStatus(e.statusCode ?? 500);
      state = state.copyWith(
        errorMessage: _getErrorMessage(status),
        isLoading: false,
        status: status,
        statusCode: e.statusCode,
        imageSource: ImageSource.none,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
        status: RequestStatus.error,
        statusCode: null,
        imageSource: ImageSource.none,
      );
    }
  }

  ImageServiceType _getServiceType() {
    switch (state.selectedTab) {
      case ImageTab.dallE:
        return ImageServiceType.dallE;
      case ImageTab.stableDiffusion:
        return ImageServiceType.stableDiffusion;
      case ImageTab.deepSeek:
        return ImageServiceType.deepSeek;
    }
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: RequestStatus.initial,
      statusCode: null,
    );
  }
} 
