library tekartik_jquery;

import 'dart:js';
import 'dart:html';
import 'package:tekartik_utils/string_enum.dart';
import 'package:tekartik_utils/js_utils.dart';

part 'src/jobject_base.dart';
part 'src/jobject_element.dart';
part 'src/jeffects.dart';

JsObject _querySelector(String selector) {
  return context.callMethod('jQuery', [selector]);
}

//@deprecated
JsObject queryElement(Element element) {
  return _queryElement(element);
}

JsObject _queryElement(Element element) {
  return context.callMethod('jQuery', [element]);
}

class JQuery {
  JsObject jsObject;
  JQuery(this.jsObject);
  
}

JQuery jQuery = new JQuery(context['jQuery']);

JObjectElement jQuerySelector(String selector) {
  return new JObjectElement(_querySelector(selector));
}

JObjectElement jQueryElement(Element element) {
  return new JObjectElement(_queryElement(element));
}
