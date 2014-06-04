library tekartik_jquery;

import 'dart:js';
import 'dart:html';
import 'package:tekartik_utils/string_enum.dart';

part 'src/jobject_base.dart';
part 'src/jobject_element.dart';
part 'src/jeffects.dart';

JsObject _querySelector(String selector) {
  return context.callMethod('jQuery', [selector]);
}

JsObject queryElement(Element element) {
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
