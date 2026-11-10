/// jQuery from Dart (dart:js_interop, dart2js and dart2wasm): the [jQuery]
/// of the page and [JElement] / [JElementList] wrappers of jQuery objects.
/// Load jQuery first with `package:tekartik_jquery/jquery_loader.dart`.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:pub_semver/pub_semver.dart';
import 'package:web/web.dart' as web;

import 'jquery.dart';
import 'src/js_prv.dart';
import 'src/utils_prv.dart';

export 'src/jeffects.dart';
export 'src/jelement.dart';
export 'src/jelement_list.dart';
export 'src/jobject_base.dart';
export 'src/jobject_element.dart';

/// The oldest jQuery accepted by [jQuery].
Version get jQueryVersionMin => Version(2, 1, 4);

/// The jQuery 2 of tekartik_jquery_asset.
Version get jQueryVersion2Default => Version(2, 1, 4);

/// The first jQuery 3 of tekartik_jquery_asset.
Version get jQueryVersion3Min => Version(3, 1, 1);

/// The jQuery loaded by default.
Version get jQueryVersionDefault => Version(3, 1, 1);

/// `jQuery(element)`.
@Deprecated('Use jQuery')
JSObject? queryElement(web.Element element) {
  return _queryElement(element);
}

/// `jQuery(document)`.
JSObject? get jsDocument {
  return callJQuery([web.document]);
}

/// `jQuery(element)`.
JSObject? jsElement(web.Element element) {
  return _queryElement(element);
}

JSObject? _queryElement(web.Element element) {
  return callJQuery([element]);
}

JSObject? _queryElementList(List<web.Element> elements) {
  var jsObject = callJQuery([]); // An empty jQuery object
  for (var element in elements) {
    jsObject = jsCall(jsObject!, 'add', [element]) as JSObject?;
  }
  return jsObject;
}

/// The jQuery function of the page.
class JQuery {
  final JSObject? _jsObject;

  /// The `jQuery` function.
  JSObject? get jsObject => _jsObject;

  JQuery._(this._jsObject);

  Version? _version;

  /// Its version (`jQuery.fn.jquery`).
  Version? get version {
    _version ??= Version.parse(fn('jquery') as String);
    return _version;
  }

  /// `jQuery.fn[key]`: a String, num or bool as a Dart value, other values
  /// as JS values.
  dynamic fn(Object key) =>
      jsResult((_jsObject!['fn'] as JSObject).getProperty(jsArg(key)!));

  /// `jQuery[key]`, converted as [fn].
  dynamic operator [](Object key) =>
      jsResult(_jsObject!.getProperty(jsArg(key)!));
}

JQuery? _jQuery;

JSObject? get _jsQuery => globalContext.getProperty<JSObject?>('jQuery'.toJS);

/// raw js jQuery object
/// only to use to test if jquery is loaded
@Deprecated('use jQuery')
JSObject? get jsQuery => _jsQuery;

/// The jQuery of the page, cached once valid. Throws a [StateError] when
/// jQuery is not loaded or older than [jQueryVersionMin].
JQuery? get jQuery {
  if (_jQuery == null) {
    // Validate before caching so that it keeps throwing until loaded
    var jq = JQuery._(_jsQuery);
    if (jq._jsObject == null) {
      throw StateError('Missing jQuery');
    }
    // test version
    var versionMin = jQueryVersionMin;
    if (jq.version! < jQueryVersionMin) {
      throw StateError("""
jquery: invalid jQuery version '${jq.version}' expected min $versionMin""");
    }
    _jQuery = jq;
  }
  return _jQuery;
}

/// `jQuery(selector)`, never null (an empty jQuery object when nothing
/// matches).
JElement? jQuerySelector(String selector) {
  return JElement(querySelector(selector)!);
}

/// `jQuery(selector)` as a list.
JElementList jQuerySelectorAll(String selector) {
  return JElementList(querySelector(selector)!);
}

/// `jQuery(element)`.
JElement? jElement(web.Element element) {
  return JElement(_queryElement(element)!);
}

/// A jQuery object on [elements].
JElementList jElementList(List<web.Element> elements) {
  return JElementList(_queryElementList(elements)!);
}

/// The version of the jQuery of the page (e.g. 2.1.0).
@Deprecated('Not supported')
String? get jQueryVersion =>
    ((globalContext['jQuery'] as JSObject)['fn'] as JSObject)['jquery']
            .dartify()
        as String?;
