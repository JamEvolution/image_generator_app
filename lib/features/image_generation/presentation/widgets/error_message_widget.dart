import 'package:flutter/material.dart';
import '../../domain/enums/request_status.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final RequestStatus status;
  final int? statusCode;

  const ErrorMessageWidget({
    super.key,
    required this.message,
    required this.status,
    this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getErrorColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getErrorIcon(status),
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (statusCode != null) ...[
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
                'HTTP $statusCode',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
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
} 