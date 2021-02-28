part of tekartik_jquery;

class JElement extends JObjectBase with JObjectWithElement {
  JElement(JsObject jsObject) : super(jsObject);

  factory JElement.fromElement(Element element) =>
      JElement(jsElement(element)!);
}
