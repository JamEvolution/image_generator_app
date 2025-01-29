import 'package:flutter/cupertino.dart';
import '../../../../core/enums/image_service_type.dart';

class ServiceSelector extends StatelessWidget {
  final ImageServiceType selectedService;
  final void Function(ImageServiceType?) onServiceChanged;

  const ServiceSelector({
    super.key,
    required this.selectedService,
    required this.onServiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<ImageServiceType>(
      groupValue: selectedService,
      onValueChanged: onServiceChanged,
      children: {
        for (final service in ImageServiceType.values)
          service: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(service.displayName),
          ),
      },
    );
  }
} 