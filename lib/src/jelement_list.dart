// ignore_for_file: deprecated_member_use

import 'dart:html';
import 'dart:js';

import 'package:tekartik_jquery/src/utils_prv.dart';

import 'jelement.dart';
import 'jobject_base.dart';
import 'jobject_element.dart';

class JElementList extends JObjectBase with JObjectWithElement, JList<Element> {
  JElementList.empty() : super(callJQuery([])!);
  JElementList(super.jsObject);

  JElement get first => JElement(jsObject.callMethod('first', []) as JsObject);
}
