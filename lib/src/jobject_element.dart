part of tekartik_jquery;

@deprecated
class JObjectElement extends JObjectBase with JObjectWithElement {
  JObjectElement.empty() : super.empty();
  JObjectElement(JsObject jsObject) : super(jsObject);
}

abstract class JList<T> extends Object {
  JsObject get jsObject;
  int get length => jsObjectLength(jsObject);
  T operator [](int index) => jsObject[index];
}

abstract class JObjectWithElement extends Object {
  JsObject get jsObject;
  void fadeIn([FadeDuration duration]) {
    List args = [];
    if (duration != null) {
      args.add(duration.value);
    }
    jsObject.callMethod("fadeIn", args);
  }

  void hide() {
    jsObject.callMethod("hide", []);
  }

  void fadeOut([FadeDuration duration]) {
    List args = [];
    if (duration != null) {
      args.add(duration.value);
    }
    jsObject.callMethod("fadeOut", args);
  }

  String get id => getAttr('id');

  @deprecated
  /**
   * use element.attributes
   */
  String getAttr(String name) {
    return jsObject.callMethod('attr', [name]);
  }

  @deprecated
  /**
   * use element.attributes
   */
  setAttr(String name, String value) {
    return jsObject.callMethod('attr', [name, value]);
  }

  JElement querySelector(String selector) {
    return new JElement(jsObject.callMethod("find", [selector]));
  }
  
  JElementList querySelectorAll(String selector) {
      return new JElementList(jsObject.callMethod("find", [selector]));
    }

  int get _length => jsObject['length'];
  Element get element => _length > 0 ? jsObject[0] : null;
}
