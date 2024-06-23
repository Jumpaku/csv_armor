class BaseException implements Exception {
  final List<Object> causes;
  final String message;
  final String code;
  final StackTrace stackTrace = StackTrace.current;

  BaseException(this.message, this.code, this.causes);

  BaseException.wrap(this.message, this.code, Object cause) : causes = [cause];
  BaseException.join(this.message, this.code, List<BaseException> causes) : causes = causes;

  @override
  String toString() {
    var s = "";
    walk((e) {
      s += "$e\n";
    });
    return s;
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
