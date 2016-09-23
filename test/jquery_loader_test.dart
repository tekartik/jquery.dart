@TestOn("browser")
library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';
//import 'dart:html';
import 'dart:js';

void main() {

  group('loader', () {
    test('version', () async {
      // Simple test we make sure you run unit test when jquery is updated...
      expect(context['jQuery'], isNull);
      JQuery jq = await loadJQuery();
      expect(context['jQuery'], isNotNull);
      expect(jq.version, jQueryVersionDefault);
      expect(jQuery.version, jQueryVersionDefault);

      /*
      //quick test
      Element element = new DivElement();

      JElement jDiv = jElement(element);

      expect(jDiv.callMethod("attr", ["id"]), null);
      element.id = "my_id";
      expect(jDiv.callMethod("attr", ["id"]), "my_id");
      */

    });

  });


}
