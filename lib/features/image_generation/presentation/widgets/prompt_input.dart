import 'package:flutter/cupertino.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const PromptInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: 'Resim için açıklama girin...',
      padding: const EdgeInsets.all(12),
      onSubmitted: onSubmitted,
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.activeGreen),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
} 