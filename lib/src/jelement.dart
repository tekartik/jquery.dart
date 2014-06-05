part of tekartik_jquery;

class JElement extends JObjectBase with JObjectWithElement {
  JElement.empty() : super.empty();
  JElement(JsObject jsObject) : super(jsObject);
}