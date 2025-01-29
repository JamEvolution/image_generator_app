enum RequestStatus {
  initial,
  loading,
  success,
  error,
  unauthorized,  // 401
  forbidden,     // 403
  notFound,      // 404
  serverError    // 500
} 