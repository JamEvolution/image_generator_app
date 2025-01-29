import 'package:flutter/cupertino.dart';
import '../../../../core/enums/generation_status.dart';
import '../../domain/entities/image_state.dart';

class ImageDisplay extends StatelessWidget {
  final ImageState state;

  const ImageDisplay({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case GenerationStatus.loading:
        return const Center(
          child: CupertinoActivityIndicator(radius: 20),
        );
      case GenerationStatus.success:
        return Center(
          child: Image.network(
            state.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Resim yüklenemedi');
            },
          ),
        );
      case GenerationStatus.error:
        return Center(
          child: Text(
            state.errorMessage ?? 'Bir hata oluştu',
            style: const TextStyle(color: CupertinoColors.destructiveRed),
          ),
        );
      case GenerationStatus.initial:
      default:
        return Center(
          child: Text(state.status.message),
        );
    }
  }
} 