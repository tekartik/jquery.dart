library tekartik_jquery;

import 'dart:html';
import 'dart:js';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_browser_utils/js_utils.dart';

part 'src/jeffects.dart';
part 'src/jelement.dart';
part 'src/jelement_list.dart';
part 'src/jobject_base.dart';
part 'src/jobject_element.dart';

Version get jQueryVersionMin => Version(2, 1, 4);

Version get jQueryVersion2Default => Version(2, 1, 4);

Version get jQueryVersion3Min => Version(3, 1, 1);

Version get jQueryVersionDefault => Version(3, 1, 1);

JsObject? _querySelector(String selector) {
  return _callJQuery([selector]);
}

JsObject? _callJQuery(List args) {
  return context.callMethod('jQuery', args) as JsObject?;
}

/// used to version
//dynamic __callJQuery(List args) {
//  return context.callMethod('jQuery', args);
//}

@deprecated
JsObject? queryElement(Element element) {
  return _queryElement(element);
}

JsObject? get jsDocument {
  return _callJQuery([document]);
}

JsObject? jsElement(Element element) {
  return _queryElement(element);
}

JsObject? _queryElement(Element element) {
  return _callJQuery([element]);
}

JsObject? _queryElementList(List<Element> elements) {
  var jsObject = _callJQuery([]); // Notice the enclosed empty array
  //devPrint(jsObjectToDebugString(jsObject));

  // jsObject = jsObject.callMethod('add', elements);
  // as of 2014-06-05 this is the best solutions as above does not work
  elements.forEach((Element element) {
    jsObject = jsObject!.callMethod('add', [element]) as JsObject?;
    //devPrint(jsObjectToDebugString(jsObject));
  });
  return jsObject;
}

class JQuery {
  final JsObject? _jsObject;

  JsObject? get jsObject => _jsObject;

  JQuery._(this._jsObject);

  Version? _version;

  Version? get version {
    _version ??= Version.parse(fn('jquery') as String);
    return _version;
  }

  dynamic fn(Object key) => (_jsObject!['fn'] as JsObject)[key];

  dynamic operator [](Object key) => _jsObject![key];
}

JQuery? _jQuery;

JsObject? get _jsQuery => context['jQuery'] as JsObject?;

/// raw js jQuery object
/// only to use to test if jquery is loaded
@deprecated
JsObject? get jsQuery => _jsQuery;

JQuery? get jQuery {
  if (_jQuery == null) {
    _jQuery = JQuery._(_jsQuery);
    if (_jQuery!._jsObject == null) {
      throw ('Missing jQuery');
    }
    // test version
    var versionMin = jQueryVersionMin;
    if (_jQuery!.version! < jQueryVersionMin) {
      throw ("""
jquery: invalid jQuery version '${_jQuery!.version}' expected min $versionMin""");
    }
  }
  return _jQuery;
}

JElement? jQuerySelector(String selector) {
  return JElement(_querySelector(selector)!);
}

JElementList jQuerySelectorAll(String selector) {
  return JElementList(_querySelector(selector)!);
}

/*
JObjectElement jQueryElement(Element element) {
  return new JObjectElement(_queryElement(element));
}
*/

JElement? /*!*/ jElement(Element element) {
  return JElement(_queryElement(element)!);
}

JElementList jElementList(List<Element> elements) {
  return JElementList(_queryElementList(elements)!);
}

// e.g. 2.1.0
@deprecated
String? get jQueryVersion =>
    ((context['jQuery'] as JsObject)['fn'] as JsObject)['jquery'] as String?;
