library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:tekartik_utils/test_utils_browser.dart';

void main() {
  useHtmlConfiguration();

  group('loader', () {
    test('version', () {
      // Simple test we make sure you run unit test when jquery is updated...
      expect(jsQuery, null);
      return loadJQuery().then((jq) {
        expect(jsQuery, isNotNull);
        expect(jq.version, JQUERY_DEFAULT_VERSION);
        expect(jQuery.version, JQUERY_DEFAULT_VERSION);

        //quick test
        Element element = new DivElement();

        JElement jDiv = jElement(element);

        expect(jDiv.callMethod("attr", ["id"]), null);
        element.id = "my_id";
        expect(jDiv.callMethod("attr", ["id"]), "my_id");
      });
    });

  });


}
