part of tekartik_jquery;

class JElement extends JObjectBase with JObjectWithElement {
  JElement.empty() : super.empty();
  JElement(JsObject jsObject) : super(jsObject);

  factory JElement.fromElement(Element element) {
    if (element == null) {
      return null;
    }
    return JElement(jsElement(element));
  }
}
