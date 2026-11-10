@TestOn('browser')
library;

import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';
import 'package:test/test.dart';

import 'src/jquery_browser_test_common.dart';

void main() {
  jqueryBrowserTests(
    load: () => loadJQuery(version: jQueryVersion2Default),
    version: jQueryVersion2Default,
    jquery2: true,
  );
}
