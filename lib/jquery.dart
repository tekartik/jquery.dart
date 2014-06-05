library tekartik_jquery;

import 'dart:js';
import 'dart:html';
import 'package:tekartik_utils/string_enum.dart';
import 'package:tekartik_utils/js_utils.dart';
import 'package:tekartik_utils/dev_utils.dart';

part 'src/jobject_base.dart';
part 'src/jelement.dart';
part 'src/jobject_element.dart';
part 'src/jelementlist.dart';
part 'src/jeffects.dart';

JsObject _querySelector(String selector) {
  return _callJQuery([selector]);
}

JsObject _callJQuery(List args) {
  return context.callMethod('jQuery', args);
}

/**
 * used to version
 */
//dynamic __callJQuery(List args) {
//  return context.callMethod('jQuery', args);
//}

//@deprecated
JsObject queryElement(Element element) {
  return _queryElement(element);
}

JsObject _queryElement(Element element) {
  return _callJQuery([element]);
}

JsObject _queryElementList(List<Element> elements) {
  JsObject jsObject = _callJQuery([]); // Notice the enclosed empty array
  devPrint(jsObjectToDebugString(jsObject));
  
  // jsObject = jsObject.callMethod('add', elements);
  // as of 2014-06-05 this is the best solutions as above does not work
  elements.forEach((Element element) {
    jsObject = jsObject.callMethod('add', [element]);
    devPrint(jsObjectToDebugString(jsObject));
  });
  return jsObject;
}

class JQuery {
  JsObject jsObject;
  JQuery(this.jsObject);
  
}

JQuery jQuery = new JQuery(context['jQuery']);

JObjectElement jQuerySelector(String selector) {
  return new JObjectElement(_querySelector(selector));
}

JElementList jQuerySelectorAll(String selector) {
  return new JElementList(_querySelector(selector));
}

JObjectElement jQueryElement(Element element) {
  return new JObjectElement(_queryElement(element));
}

JElement jElement(Element element) {
  return new JElement(_queryElement(element));
}

JElementList jElementList(List<Element> elements) {
  return new JElementList(_queryElementList(elements));
}

// e.g. 2.1.0
String get jQueryVersion => context['jQuery']['fn']['jquery'];
