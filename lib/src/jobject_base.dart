part of tekartik_jquery;



abstract class JObjectBase {
  JsObject jsObject;
  JObjectBase.empty();
  JObjectBase(this.jsObject);

  callMethod(String method, [List args]) {
    return jsObject.callMethod(method, args);
  }
  
  String toString() => jsObjectToDebugString(jsObject);

  bool get hasLength {
    return jsObject.hasProperty('length');
  }

  int get length => jsObject['length'];
}
