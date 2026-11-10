import 'dart:js_interop';

import 'package:tekartik_jquery/src/utils_prv.dart';
import 'package:web/web.dart' as web;

import 'jelement.dart';
import 'jobject_base.dart';
import 'jobject_element.dart';
import 'js_prv.dart';

/// A jQuery object on several elements.
class JElementList extends JObjectBase
    with JObjectWithElement, JList<web.Element> {
  /// An empty list (`jQuery()`).
  JElementList.empty() : super(callJQuery([])!);

  /// Wraps a jQuery object.
  JElementList(super.jsObject);

  /// The first element (`first()`).
  JElement get first => JElement(jsCall(jsObject, 'first') as JSObject);
}
