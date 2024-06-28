void require(bool condition, List<String> paramName, String message) {
  if (!condition) {
    throw ArgumentError(message, paramName.join(", "));
  }
}
