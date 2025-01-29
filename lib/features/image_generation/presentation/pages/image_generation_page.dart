import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/image_tab.dart';
import '../providers/image_generation_notifier.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/generated_image_view.dart';
import '../widgets/image_history_grid.dart';

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
                ErrorMessageWidget(
                  message: state.errorMessage!,
                  status: state.status,
                  statusCode: state.statusCode,
                ),
              ],
              if (state.imageUrl.isNotEmpty) ...[
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GeneratedImageView(
                          imageUrl: state.imageUrl,
                          imageSource: state.imageSource,
                          status: state.status,
                        ),
                      ),
                      if (state.generatedImages.isNotEmpty) ...[
                        Expanded(
                          flex: 1,
                          child: ImageHistoryGrid(
                            images: state.generatedImages,
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
}
 