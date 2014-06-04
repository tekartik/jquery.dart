part of tekartik_jquery;

class JObjectElement extends JObjectBase with JObjectWithElement {
  JObjectElement.empty() : super.empty();
  JObjectElement(JsObject jsObject) : super(jsObject);
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

  String getAttr(String name) {
    return jsObject.callMethod('attr', [name]);
  }

  setAttr(String name, String value) {
    return jsObject.callMethod('attr', [name, value]);
  }
}
