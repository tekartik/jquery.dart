// ignore_for_file: deprecated_member_use

import 'dart:html';

import 'package:tekartik_jquery/jquery.dart';

class JElement extends JObjectBase with JObjectWithElement {
  JElement(super.jsObject);

  factory JElement.fromElement(Element element) =>
      JElement(jsElement(element)!);
}
