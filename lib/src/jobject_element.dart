part of tekartik_jquery;

/*
@deprecated
class JObjectElement extends JObjectBase with JObjectWithElement {
  JObjectElement.empty() : super.empty();
  JObjectElement(JsObject jsObject) : super(jsObject);
}
*/

abstract class JList<T> extends Object {
  JsObject get jsObject;
  int? get length => jsObject['length'] as int?;
  T? operator [](int index) => jsObject[index] as T?;
}

abstract class JObjectWithElement extends Object {
  JsObject get jsObject;
  dynamic callMethod(String method, [List? args]);
  void fadeIn([FadeDuration? duration]) {
    var args = [];
    if (duration != null) {
      args.add(duration.value);
    }
    jsObject.callMethod('fadeIn', args);
  }

  void hide() {
    callMethod('hide', []);
  }

  void show() {
    callMethod('show', []);
  }

  void fadeOut([FadeDuration? duration]) {
    var args = [];
    if (duration != null) {
      args.add(duration.value);
    }
    jsObject.callMethod('fadeOut', args);
  }

  String get id => element!.id;

  @deprecated

  /// use element.attributes
  String? getAttr(String name) {
    return jsObject.callMethod('attr', [name]) as String?;
  }

  @deprecated

  /// use element.attributes
  dynamic setAttr(String name, String value) {
    return jsObject.callMethod('attr', [name, value]);
  }

  JElement querySelector(String selector) {
    return JElement(jsObject.callMethod('find', [selector]) as JsObject);
  }

  JElementList querySelectorAll(String selector) {
    return JElementList(jsObject.callMethod('find', [selector]) as JsObject);
  }

  int? get _length => jsObject['length'] as int?;
  Element? get element => _length! > 0 ? (jsObject[0] as Element?) : null;
}
