@TestOn("browser")
library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:test/test.dart';

void main() {
  group('loader', () {
    test('not loaded', () {
      try {
        jQuery;
        throw ('should throw');
      } catch (_) {}
    });
  });
}
