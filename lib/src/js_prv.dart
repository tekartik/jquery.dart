import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// A Dart value as a JS argument: String, num, bool, null, a Map or a List
/// (converted deeply), or a JS value (an element, a jQuery object), kept.
JSAny? jsArg(Object? value) => value.jsify();

/// A JS result as a Dart value: a JS string, number or boolean becomes a
/// String, an int (when integral) or double, a bool; undefined becomes null;
/// any other JS value (an object, an element, a function) is returned as is.
Object? jsResult(JSAny? value) {
  if (value == null || value.isUndefinedOrNull) {
    return null;
  }
  if (value.isA<JSString>()) {
    return (value as JSString).toDart;
  }
  if (value.isA<JSBoolean>()) {
    return (value as JSBoolean).toDart;
  }
  if (value.isA<JSNumber>()) {
    var number = (value as JSNumber).toDartDouble;
    if (number == number.truncateToDouble() &&
        number.abs() <= 9007199254740991) {
      return number.toInt();
    }
    return number;
  }
  return value;
}

/// Calls [method] on [object] with [args] converted by [jsArg].
JSAny? jsCall(JSObject object, String method, [List<Object?>? args]) =>
    object.callMethodVarArgs<JSAny?>(method.toJS, [
      for (var arg in args ?? const <Object?>[]) jsArg(arg),
    ]);
