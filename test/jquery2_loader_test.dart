@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

void main() {
  group('loader', () {
    test('version', () async {
      // Simple test we make sure you run unit test when jquery is updated...
      expect(globalContext['jQuery'], isNull);
      var jq = (await loadJQuery(version: jQueryVersion2Default))!;
      expect(globalContext['jQuery'], isNotNull);
      expect(jq.version, jQueryVersion2Default);
      expect(jQuery!.version, jQueryVersion2Default);
    });
  });
}
