import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:tekartik_js_utils_interop/js_converter.dart';

import 'js_prv.dart';

/// A jQuery object (the result of `jQuery(...)`).
abstract class JObjectBase {
  /// The jQuery object.
  JSObject jsObject;

  /// Wraps [jsObject].
  JObjectBase(this.jsObject);

  /// Calls the jQuery [method] with [args]: Dart String, num, bool, null,
  /// Map and List arguments are converted, JS values (elements, jQuery
  /// objects) passed as is. A string, number or boolean result is returned
  /// as a Dart value, undefined as null, any other result as a JS value
  /// (cast it to `JSObject`).
  dynamic callMethod(String method, [List? args]) {
    return jsResult(jsCall(jsObject, method, args));
  }

  @override
  String toString() => jsAnyToDebugString(jsObject) ?? 'null';

  /// Whether the object has a length (every jQuery object has one).
  bool get hasLength {
    return jsObject.has('length');
  }

  /// The number of elements.
  int? get length => (jsObject['length'] as JSNumber?)?.toDartInt;
}
