@TestOn('browser')
library jquery_browser_test;

import 'dart:js';

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';
//import 'dart:html';

void main() {
  group('loader', () {
    test('version', () async {
      // Simple test we make sure you run unit test when jquery is updated...
      expect(context['jQuery'], isNull);
      var jq = (await loadJQuery(version: jQueryVersion2Default))!;
      expect(context['jQuery'], isNotNull);
      expect(jq.version, jQueryVersion2Default);
      expect(jQuery!.version, jQueryVersion2Default);

      /*
      //quick test
      Element element = new DivElement();

      JElement jDiv = jElement(element);

      expect(jDiv.callMethod('attr', ['id']), null);
      element.id = 'my_id';
      expect(jDiv.callMethod('attr', ['id']), 'my_id');
      */
    });
  });
}
