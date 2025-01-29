import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/image_generation_notifier.dart';
import '../providers/image_generation_state.dart';

class ImageGenerationPage extends ConsumerWidget {
  const ImageGenerationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageGenerationNotifierProvider);
    final notifier = ref.read(imageGenerationNotifierProvider.notifier);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Görsel Oluşturucu'),
          bottom: TabBar(
            onTap: (index) {
              notifier.changeTab(ImageTab.values[index]);
            },
            tabs: const [
              Tab(text: 'DALL-E'),
              Tab(text: 'Stable Diffusion'),
              Tab(text: 'DeepSeek'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Görsel için bir açıklama girin...',
                  border: OutlineInputBorder(),
                ),
                onChanged: notifier.updatePrompt,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: state.isLoading ? null : notifier.generateImage,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Görsel Oluştur'),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getErrorColor(state.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getErrorIcon(state.status),
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (state.statusCode != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'HTTP ${state.statusCode}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (state.imageUrl.isNotEmpty) ...[
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Image.network(
                              state.imageUrl,
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
                            if (state.status == RequestStatus.success)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Tooltip(
                                  message: state.imageSource == ImageSource.model
                                      ? 'Bu görsel yapay zeka tarafından oluşturuldu'
                                      : 'Bu bir test görseli',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getSourceColor(state.imageSource),
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
                                          _getSourceIcon(state.imageSource),
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _getSourceText(state.imageSource),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (state.generatedImages.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Önceki Görseller',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: state.generatedImages.length,
                            itemBuilder: (context, index) {
                              final imageUrl = state.generatedImages[index];
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            imageUrl,
                                            fit: BoxFit.contain,
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: IconButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              icon: const Icon(Icons.close),
                                              color: Colors.white,
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getErrorColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.unauthorized:
        return Colors.orange;
      case RequestStatus.forbidden:
        return Colors.red.shade700;
      case RequestStatus.notFound:
        return Colors.grey.shade700;
      case RequestStatus.serverError:
        return Colors.red.shade900;
      default:
        return Colors.red;
    }
  }

  IconData _getErrorIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.unauthorized:
        return Icons.vpn_key;
      case RequestStatus.forbidden:
        return Icons.block;
      case RequestStatus.notFound:
        return Icons.search_off;
      case RequestStatus.serverError:
        return Icons.error;
      default:
        return Icons.warning;
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
 