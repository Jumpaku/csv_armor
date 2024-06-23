class BaseException implements Exception {
  final List<Object> causes;
  final String message;
  final StackTrace stackTrace = StackTrace.current;

  BaseException(this.message, this.causes);

  BaseException.wrap(this.message, Object cause) : causes = [cause];

  @override
  String toString() {
    var s = "";
    walk((e) {
      s += "$e\n";
    });
    return s;
  }

  join(BaseException e) {
    causes.add(e);
    return this;
  }

  walk(Function(Object) f) {
    for (var cause in causes) {
      f(cause);
      if (cause is BaseException) {
        cause.walk(f);
      }
    }
  }
}
