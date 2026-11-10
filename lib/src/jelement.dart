import 'package:tekartik_jquery/jquery.dart';
import 'package:web/web.dart' as web;

/// A jQuery object on one element.
class JElement extends JObjectBase with JObjectWithElement {
  /// Wraps a jQuery object.
  JElement(super.jsObject);

  /// `jQuery(element)`.
  factory JElement.fromElement(web.Element element) =>
      JElement(jsElement(element)!);
}
