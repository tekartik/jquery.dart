@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:test/test.dart';

void expectJQueryThrows() {
  try {
    jQuery;
    throw TestFailure('should throw');
  } catch (e) {
    expect(e, isNot(isA<TestFailure>()));
  }
}

void main() {
  group('loader', () {
    test('not loaded', () {
      expectJQueryThrows();
      // Not cached, still throws
      expectJQueryThrows();
    });

    test('version too old then ok', () {
      try {
        // fake jQuery object, only fn.jquery is read
        globalContext['jQuery'] = {
          'fn': {'jquery': '1.0.0'},
        }.jsify();
        expectJQueryThrows();
        expectJQueryThrows();
        globalContext['jQuery'] = {
          'fn': {'jquery': '3.0.0'},
        }.jsify();
        expect(jQuery!.version, Version(3, 0, 0));
      } finally {
        globalContext.delete('jQuery'.toJS);
      }
    });
  });
}
