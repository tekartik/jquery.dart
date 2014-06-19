library tekartik_jquery_loader;

import 'package:tekartik_utils/js_utils.dart';
import 'package:tekartik_utils/dev_utils.dart';
import 'package:tekartik_utils/version.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'dart:async';

Version get JQUERY_DEFAULT_VERSION => new Version(2, 1, 0);

Future<JQuery> loadJQuery({Version version}) {
  if (version == null) {
    version = JQUERY_DEFAULT_VERSION;
  }

  // already loaded?
  if (jsQuery != null) {
    if (jQuery.version < version) {
      devError("jQuery version expected $version but currently loaded is ${jQuery.version}");
    }
    return new Future.value(jQuery);
  }

  // load jquery
  return loadJavascriptScript("packages/tekartik_jquery_asset/jquery/$version/jquery-$version.min.js").then((_) {
    return jQuery;
  });
}
