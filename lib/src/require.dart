void require(bool condition, String paramName, String message) {
  if (!condition) {
    throw ArgumentError(message, paramName);
  }
}
