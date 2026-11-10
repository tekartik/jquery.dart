@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

/// The script tags loading jQuery 3.1.1 from tekartik_jquery_asset.
int jQueryScriptCount() => web.document
    .querySelectorAll('script[src*="tekartik_jquery_asset/3.1.1"]')
    .length;

void main() {
  test('concurrent loads add one script', () async {
    expect(globalContext['jQuery'], isNull);
    var results = await Future.wait([loadJQuery(), loadJQuery()]);
    expect(results[0]!.version, jQueryVersionDefault);
    expect(results[1]!.version, jQueryVersionDefault);
    // Used to add two script tags (jQuery ran twice)
    expect(jQueryScriptCount(), 1);
    await loadJQuery();
    expect(jQueryScriptCount(), 1);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
