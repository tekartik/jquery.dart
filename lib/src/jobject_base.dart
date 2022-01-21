part of tekartik_jquery;

abstract class JObjectBase {
  JsObject jsObject;
  JObjectBase(this.jsObject);

  dynamic callMethod(String method, [List? args]) {
    return jsObject.callMethod(method, args);
  }

  @override
  String toString() => jsObjectToDebugString(jsObject)!;

  bool get hasLength {
    return jsObject.hasProperty('length');
  }

  int? get length => jsObject['length'] as int?;
}
