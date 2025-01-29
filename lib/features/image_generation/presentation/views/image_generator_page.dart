import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/generation_status.dart';
import '../../../../core/enums/image_service_type.dart';
import '../providers/image_generation_providers.dart';
import '../widgets/image_display.dart';
import '../widgets/prompt_input.dart';
import '../widgets/service_selector.dart';

class ImageGeneratorPage extends ConsumerStatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  ConsumerState<ImageGeneratorPage> createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends ConsumerState<ImageGeneratorPage> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imageGenerationStateProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Image Generator'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ServiceSelector(
                selectedService: ref.watch(selectedServiceProvider),
                onServiceChanged: (value) {
                  if (value != null) {
                    ref.read(selectedServiceProvider.notifier).state = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              PromptInput(
                controller: _promptController,
                onSubmitted: _generateImage,
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () => _generateImage(_promptController.text),
                child: const Text('Resim Oluştur'),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ImageDisplay(state: imageState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateImage(String prompt) {
    if (prompt.isNotEmpty) {
      ref.read(imageGenerationStateProvider.notifier).generateImage(prompt);
    }
  }
} 