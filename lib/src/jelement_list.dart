part of tekartik_jquery;

class JElementList extends JObjectBase with JObjectWithElement, JList<Element> {
  JElementList.empty() : super(_callJQuery([]));
  JElementList(JsObject jsObject) : super(jsObject);

  JElement get first => JElement(jsObject.callMethod('first', []) as JsObject);
}
