@TestOn('browser')
library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:test/test.dart';

void main() {
  group('loaded', () {
    test('version', () {
      expect(jQuery!.version, jQueryVersionDefault);
    });
  });
}
