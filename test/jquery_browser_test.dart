@TestOn("browser")
library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:tekartik_utils/js_utils.dart';
import 'package:test/test.dart';
import 'dart:js';
import 'dart:html';

void main() {

  setUp(() async {
    await loadJQuery();
  });

  group('Global', () {


    test('version', () {
      // Simple test we make sure you run unit test when jquery is updated...
      expect(jQuery.version >= jQueryVersionMin, isTrue);
      expect(jQuery.version, jQueryVersionDefault);
    });
  });
  
  
  group('JElement', () {
    test('element', () {
      Element element = new DivElement();
      JElement jDiv = jElement(element);
      expect(element, jDiv.element);
    });
    test('call method', () {
        Element element = new DivElement();
        
        JElement jDiv = jElement(element);
        
        expect(jDiv.callMethod("attr", ["id"]), null);
        element.id = "my_id";
        expect(jDiv.callMethod("attr", ["id"]), "my_id");
      });
    test('querySelector', () {
      expect(jQuerySelector('body').element, document.body);
      expect(jQuerySelector('nobody').element, null);
    });
  });

  group('JElementList', () {
    test('empty', () {
      JElementList list = new JElementList.empty();
      expect(list.length, 0);
      //expect(element, list[0]);
      //expect(element2, list[1]);
    });
    test('elements', () {
      Element element = new DivElement();
      Element element2 = new DivElement();
      JElementList list = jElementList([element, element2]);
      expect(list.length, 2);
      expect(element, list[0]);
      //expect(element2, list[1]);
    });

    test('querySelector', () {
      expect(jQuerySelectorAll('body').length, 1);
      expect(jQuerySelectorAll('body').first.element, document.body);
    });

    test('querySelector', () {
      Element element = new DivElement()
          ..id = "my_id"
          ..classes = ["my-class"]
          ..attributes['test'] = 'value1';

      Element element2 = new DivElement()
          ..id = "my_id2"
          ..classes = ["my-class"]
          ..attributes['test'] = 'value2';

      Element container = new DivElement();
      container.children.addAll([element, element2]);
      JElement jContainer = jElement(container);
      JElementList list = jContainer.querySelectorAll(".my-class");
      expect(list.length, 2);
      expect(list[0], element);
      expect(list[1], element2);

      expect(jContainer.querySelector(".my-class").element, element);

      list = jContainer.querySelectorAll("#my_id2");
      expect(list.length, 1);
      expect(list[0], element2);

      expect(jContainer.querySelector("#my_id2").element, element2);
    });
  });

  group('JObjectElement', () {
    test('id and attr', () {
      Element element = new DivElement()
          ..id = "my_id"
          ..attributes['test'] = 'value1';
      JElement jDiv = jElement(element);
      expect(jDiv.id, 'my_id');
      expect(jDiv.element.attributes['test'], 'value1');
    });

    test('JsObject', () {
      Element element = new DivElement()
          ..id = "my_id"
          ..attributes['test'] = 'value1';
      JElement jDiv = jElement(element);
      JsObject jsObject = jDiv.jsObject;
      expect(jDiv.jsObject.runtimeType, JsObject);
      expect(jsRuntimeType(jDiv.jsObject), ''); // Empty runtime type
      // Currently 3 keys
      expect(jsObjectKeys(jDiv.jsObject).length, 3);
      expect(jsObject['0'], element);
      expect(jsObject[0], element);
      expect(jsObject["context"], element);
      expect(jsObject["length"], 1);

      Element element2 = new DivElement()
          ..id = "my_id2"
          ..attributes['test'] = 'value2';

      Element container = new DivElement();
      container.children.addAll([element, element2]);
      //JElement jContainer = jElement(container);
      //jElement.q
      //que

    });
  });

}
