import 'package:flutter/material.dart';
import '../../domain/enums/image_source.dart';
import '../../domain/enums/request_status.dart';
import 'image_source_badge.dart';

class GeneratedImageView extends StatelessWidget {
  final String imageUrl;
  final ImageSource imageSource;
  final RequestStatus status;

  const GeneratedImageView({
    super.key,
    required this.imageUrl,
    required this.imageSource,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Görsel yüklenemedi'),
            );
          },
        ),
        if (status == RequestStatus.success)
          Positioned(
            top: 8,
            right: 8,
            child: ImageSourceBadge(source: imageSource),
          ),
      ],
    );
  }
} 