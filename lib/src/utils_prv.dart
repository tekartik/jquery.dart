import 'dart:js';

JsObject? querySelector(String selector) {
  return callJQuery([selector]);
}

JsObject? callJQuery(List args) {
  return context.callMethod('jQuery', args) as JsObject?;
}
