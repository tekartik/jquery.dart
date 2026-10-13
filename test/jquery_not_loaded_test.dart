// ignore_for_file: deprecated_member_use

@TestOn('browser')
library;

import 'dart:js';

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
        context['jQuery'] = JsObject.jsify({
          'fn': {'jquery': '1.0.0'},
        });
        expectJQueryThrows();
        expectJQueryThrows();
        context['jQuery'] = JsObject.jsify({
          'fn': {'jquery': '3.0.0'},
        });
        expect(jQuery!.version, Version(3, 0, 0));
      } finally {
        context.deleteProperty('jQuery');
      }
    });
  });
}
