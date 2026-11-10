/// Adds jQuery to the page: [loadJQuery] (the copy of tekartik_jquery_asset)
/// or [loadCdnJQuery] (ajax.googleapis.com).
library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_browser_utils/js_utils.dart';

import 'jquery.dart';

/// The loads started, by script url: concurrent calls share one script tag;
/// a failed load is removed, the next call retries.
final _loads = <String, Future<void>>{};

Future<void> _loadScriptOnce(String src) {
  return _loads[src] ??= () async {
    try {
      await loadJavascriptScript(src);
    } catch (e, st) {
      unawaited(_loads.remove(src));
      Error.throwWithStackTrace(e, st);
    }
  }();
}

/// The jQuery already in the page, checked against [version]; null when
/// there is none.
JQuery? _loadedJQuery(Version version) {
  if (globalContext['jQuery'] == null) {
    return null;
  }
  if (jQuery!.version! < version) {
    throw StateError(
      'jQuery version expected $version but currently loaded is ${jQuery!.version}',
    );
  }
  return jQuery;
}

/// Adds the jQuery [version] of tekartik_jquery_asset to the page
/// ([jQueryVersionDefault], 3.1.1, by default) and returns [jQuery]. Returns
/// the jQuery already in the page when there is one (throws a [StateError]
/// when it is older than [version]).
///
/// Concurrent calls for the same version share one load (one script tag).
/// The script url is relative to the page:
/// `packages/tekartik_jquery_asset/<version>/...`.
Future<JQuery?> loadJQuery({Version? version}) async {
  version ??= jQueryVersionDefault;

  // already loaded?
  var loaded = _loadedJQuery(version);
  if (loaded != null) {
    return loaded;
  }

  // load jquery
  if (version < jQueryVersion3Min) {
    await _loadScriptOnce(
      'packages/tekartik_jquery_asset/$version/jquery-$version.min.js',
    );
  } else {
    await _loadScriptOnce(
      'packages/tekartik_jquery_asset/$version/jquery.min.js',
    );
  }
  return jQuery;
}

/// Same as [loadJQuery], from ajax.googleapis.com.
Future<JQuery?> loadCdnJQuery({Version? version}) async {
  version ??= jQueryVersionDefault;

  // already loaded?
  var loaded = _loadedJQuery(version);
  if (loaded != null) {
    return loaded;
  }

  // load jquery from google
  // https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js
  await _loadScriptOnce(
    '//ajax.googleapis.com/ajax/libs/jquery/$version/jquery.min.js',
  );
  return jQuery;
}
