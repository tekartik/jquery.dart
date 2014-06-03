part of tekartik_jquery;

class JObjectElement extends JObjectBase with JObjectWithElement {
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
}