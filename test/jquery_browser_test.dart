library jquery_browser_test;

import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:tekartik_jquery/jquery.dart';

void main() {
  group('JObjectElement', () {
    test('id and attr', () {
      Element element = new DivElement()..id = "my_id"..attributes['test'] = 'value1';
      JObjectElement jElement = jQueryElement(element);
      expect(jElement.id, 'my_id');
      expect(jElement.getAttr('test'), 'value1');
      jElement.setAttr('test2', 'value2');
      expect(element.attributes['test2'], 'value2');
      
    });    
  });

}
