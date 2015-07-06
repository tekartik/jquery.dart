@TestOn("browser")
library jquery_browser_test;

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';
import 'dart:html';

void main() {

  group('loader', () {

    test('not loaded', () {
      try {
        jQuery;
        throw ('should throw');
      } catch (e) {

      }
    });

  });


}
