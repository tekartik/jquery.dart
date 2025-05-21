// ignore_for_file: deprecated_member_use

import 'dart:js';

JsObject? querySelector(String selector) {
  return callJQuery([selector]);
}

JsObject? callJQuery(List args) {
  return context.callMethod('jQuery', args) as JsObject?;
}
