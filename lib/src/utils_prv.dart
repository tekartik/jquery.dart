import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'js_prv.dart';

/// `jQuery(selector)`.
JSObject? querySelector(String selector) {
  return callJQuery([selector]);
}

/// `jQuery(...args)`, throws a [StateError] when jQuery is not loaded.
JSObject? callJQuery(List<Object?> args) {
  if (globalContext['jQuery'] == null) {
    throw StateError('Missing jQuery');
  }
  return jsCall(globalContext, 'jQuery', args) as JSObject?;
}
