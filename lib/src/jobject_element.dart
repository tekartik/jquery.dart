import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'jeffects.dart';
import 'jelement.dart';
import 'jelement_list.dart';
import 'js_prv.dart';

/// Indexed access to the items of a jQuery object.
abstract mixin class JList<T extends JSAny?> extends Object {
  /// The jQuery object.
  JSObject get jsObject;

  /// The number of items.
  int? get length => (jsObject['length'] as JSNumber?)?.toDartInt;

  /// Item [index], null past the end.
  T? operator [](int index) => jsObject.getProperty<T?>(index.toJS);
}

/// The element methods of a jQuery object.
abstract mixin class JObjectWithElement extends Object {
  /// The jQuery object.
  JSObject get jsObject;

  /// Calls a jQuery method.
  dynamic callMethod(String method, [List? args]);

  /// `fadeIn([duration])`.
  void fadeIn([FadeDuration? duration]) {
    jsCall(jsObject, 'fadeIn', [?duration?.value]);
  }

  /// `hide()`.
  void hide() {
    callMethod('hide', []);
  }

  /// `show()`.
  void show() {
    callMethod('show', []);
  }

  /// `fadeOut([duration])`.
  void fadeOut([FadeDuration? duration]) {
    jsCall(jsObject, 'fadeOut', [?duration?.value]);
  }

  /// The id of the first element.
  String get id => element!.id;

  @Deprecated('Use element.attributes')
  /// use element.attributes
  String? getAttr(String name) {
    return callMethod('attr', [name]) as String?;
  }

  @Deprecated('Use element.attributes')
  /// use element.attributes
  dynamic setAttr(String name, String value) {
    return callMethod('attr', [name, value]);
  }

  /// `find(selector)`, the first match in an element.
  JElement querySelector(String selector) {
    return JElement(jsCall(jsObject, 'find', [selector]) as JSObject);
  }

  /// `find(selector)`, every match.
  JElementList querySelectorAll(String selector) {
    return JElementList(jsCall(jsObject, 'find', [selector]) as JSObject);
  }

  int? get _length => (jsObject['length'] as JSNumber?)?.toDartInt;

  /// The first element, null when none.
  web.Element? get element =>
      _length! > 0 ? jsObject.getProperty<web.Element?>(0.toJS) : null;
}
