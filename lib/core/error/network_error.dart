class NetworkError implements Exception {
  final String message;
  final int? statusCode;

  NetworkError({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
} 