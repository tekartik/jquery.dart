@TestOn('browser')
library jquery_browser_test;

import 'dart:html';
import 'dart:js';

import 'package:dev_test/test.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:tekartik_js_utils/js_utils.dart';

void main() {
  setUp(() async {
    //await loadJQuery();
    await loadJQuery(version: jQueryVersion2Default);
  });

  group('Global', () {
    test('version', () {
      // Simple test we make sure you run unit test when jquery is updated...
      expect(jQuery!.version! >= jQueryVersionMin, isTrue);
      expect(jQuery!.version, jQueryVersion2Default);
    });

    test('map', () {
      expect(jQuery!.fn('jquery'), jQuery!.version.toString());
    });
  });

  group('JElement', () {
    test('element', () {
      Element element = DivElement();
      var jDiv = jElement(element)!;
      expect(element, jDiv.element);
    });
    test('call method', () {
      Element element = DivElement();

      var jDiv = jElement(element)!;

      expect(jDiv.callMethod('attr', ['id']), null);
      element.id = 'my_id';
      expect(jDiv.callMethod('attr', ['id']), 'my_id');
    });
    test('querySelector', () {
      expect(jQuerySelector('body')!.element, document.body);
      expect(jQuerySelector('nobody')!.element, null);
    });
  });

  group('JElementList', () {
    test('empty', () {
      var list = JElementList.empty();
      expect(list.length, 0);
      //expect(element, list[0]);
      //expect(element2, list[1]);
    });
    test('elements', () {
      Element element = DivElement();
      Element element2 = DivElement();
      var list = jElementList([element, element2]);
      expect(list.length, 2);
      expect(element, list[0]);
      //expect(element2, list[1]);
    });

    test('querySelector', () {
      expect(jQuerySelectorAll('body').length, 1);
      expect(jQuerySelectorAll('body').first.element, document.body);
    });

    test('querySelector', () {
      Element element = DivElement()
        ..id = 'my_id'
        ..classes = ['my-class']
        ..attributes['test'] = 'value1';

      Element element2 = DivElement()
        ..id = 'my_id2'
        ..classes = ['my-class']
        ..attributes['test'] = 'value2';

      Element container = DivElement();
      container.children.addAll([element, element2]);
      var jContainer = jElement(container)!;
      var list = jContainer.querySelectorAll('.my-class');
      expect(list.length, 2);
      expect(list[0], element);
      expect(list[1], element2);

      expect(jContainer.querySelector('.my-class').element, element);

      list = jContainer.querySelectorAll('#my_id2');
      expect(list.length, 1);
      expect(list[0], element2);

      expect(jContainer.querySelector('#my_id2').element, element2);
    });
  });

  group('JObjectElement', () {
    test('id and attr', () {
      Element element = DivElement()
        ..id = 'my_id'
        ..attributes['test'] = 'value1';
      var jDiv = jElement(element)!;
      expect(jDiv.id, 'my_id');
      expect(jDiv.element!.attributes['test'], 'value1');
    });

    test('JsObject', () {
      Element element = DivElement()
        ..id = 'my_id'
        ..attributes['test'] = 'value1';
      var jDiv = jElement(element)!;
      var jsObject = jDiv.jsObject;
      expect(jDiv.jsObject.runtimeType, JsObject);
      // expect(jsRuntimeType(jDiv.jsObject), ''); // Empty runtime type 'r' NOT TRUE on chrome
      // Currently 3 keys
      // print(jsObjectToDebugString(jDiv.jsObject));
      // {0: div, context: div, length: 1}
      // was 3
      expect(jsObjectKeys(jDiv.jsObject).length, 1);
      expect(jsObject['0'], element);
      expect(jsObject[0], element);
      expect(jsObject['context'], element);
      expect(jsObject['length'], 1);

      Element element2 = DivElement()
        ..id = 'my_id2'
        ..attributes['test'] = 'value2';

      Element container = DivElement();
      container.children.addAll([element, element2]);
      //JElement jContainer = jElement(container);
      //jElement.q
      //que
    });
  });
}
