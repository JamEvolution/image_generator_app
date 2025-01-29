import 'package:flutter/material.dart';
import '../../domain/enums/image_source.dart';

class ImageSourceBadge extends StatelessWidget {
  final ImageSource source;

  const ImageSourceBadge({
    super.key,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _getTooltipMessage(source),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: _getSourceColor(source),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getSourceIcon(source),
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              _getSourceText(source),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTooltipMessage(ImageSource source) {
    switch (source) {
      case ImageSource.model:
        return 'Bu görsel yapay zeka tarafından oluşturuldu';
      case ImageSource.mock:
        return 'Bu bir test görseli';
      case ImageSource.none:
        return 'Görsel yok';
    }
  }

  Color _getSourceColor(ImageSource source) {
    switch (source) {
      case ImageSource.model:
        return Colors.green;
      case ImageSource.mock:
        return Colors.orange;
      case ImageSource.none:
        return Colors.grey;
    }
  }

  IconData _getSourceIcon(ImageSource source) {
    switch (source) {
      case ImageSource.model:
        return Icons.auto_awesome;
      case ImageSource.mock:
        return Icons.data_array;
      case ImageSource.none:
        return Icons.image_not_supported;
    }
  }

  String _getSourceText(ImageSource source) {
    switch (source) {
      case ImageSource.model:
        return 'AI Üretimi';
      case ImageSource.mock:
        return 'Test Verisi';
      case ImageSource.none:
        return 'Görsel Yok';
    }
  }
} 