@TestOn('browser')
library;

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
