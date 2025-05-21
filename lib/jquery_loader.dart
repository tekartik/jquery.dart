// ignore_for_file: deprecated_member_use

library;

import 'dart:async';
import 'dart:js';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_browser_utils/js_utils.dart';

import 'jquery.dart';

Future<JQuery?> loadJQuery({Version? version}) async {
  version ??= jQueryVersionDefault;

  // already loaded?
  if (context['jQuery'] != null) {
    if (jQuery!.version! < version) {
      throw ('jQuery version expected $version but currently loaded is ${jQuery!.version}');
    }
    return jQuery;
  }

  // load jquery
  // for 2.1.0 await loadJavascriptScript("packages/tekartik_jquery_asset/jquery/$version/jquery-$version.min.js");
  if (version < jQueryVersion3Min) {
    await loadJavascriptScript(
      'packages/tekartik_jquery_asset/$version/jquery-$version.min.js',
    );
  } else {
    await loadJavascriptScript(
      'packages/tekartik_jquery_asset/$version/jquery.min.js',
    );
  }
  return jQuery;
}

Future<JQuery?> loadCdnJQuery({Version? version}) async {
  version ??= jQueryVersionDefault;

  // already loaded?
  if (context['jQuery'] != null) {
    if (jQuery!.version! < version) {
      throw ('jQuery version expected $version but currently loaded is ${jQuery!.version}');
    }
    return jQuery;
  }

  // load jquery from google
  // https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js
  await loadJavascriptScript(
    '//ajax.googleapis.com/ajax/libs/jquery/$version/jquery.min.js',
  );
  return jQuery;
}
