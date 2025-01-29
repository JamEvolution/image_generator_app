enum GenerationStatus {
  initial,
  loading,
  success,
  error;

  String get message {
    switch (this) {
      case GenerationStatus.initial:
        return 'Resim oluşturmak için yukarıdaki alana bir açıklama girin';
      case GenerationStatus.loading:
        return 'Resim oluşturuluyor...';
      case GenerationStatus.success:
        return 'Resim başarıyla oluşturuldu';
      case GenerationStatus.error:
        return 'Bir hata oluştu';
    }
  }
} 