# tekartik_jquery

Dart wrapper around the [jQuery](https://jquery.com) javascript library: load
it, select elements, `hide` / `show` / `fadeIn` / `fadeOut`, and call any
other jQuery method through `callMethod`.

It is built on `dart:js_interop` and `package:web`: browser only, compiled
with dart2js or dart2wasm (`dart compile js` / `dart compile wasm`,
`build_web_compilers`, a Flutter web build with `--wasm`). It does not run on
the Dart VM (`isJQuerySupported` in `src/export.dart` says so).

## Getting started

Git dependency (not on pub.dev, the package is at the repository root). It
brings `tekartik_jquery_asset`, the jQuery files served under
`packages/tekartik_jquery_asset/`:

```yaml
dependencies:
  tekartik_jquery:
    git:
      url: https://github.com/tekartik/jquery.dart
```

```dart
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';

Future<void> main() async {
  // Adds packages/tekartik_jquery_asset/3.1.1/jquery.min.js to the page,
  // or returns the jQuery already there.
  await loadJQuery();
  print('jQuery ${jQuery!.version}');

  jQuerySelector('#status')!
    ..hide()
    ..fadeIn(FadeDuration.slow);
}
```

## What it holds

- `package:tekartik_jquery/jquery_loader.dart`: `loadJQuery({version})` (the
  bundled asset, 3.1.1 by default, `version: jQueryVersion2Default` for
  2.1.4), `loadCdnJQuery({version})` (from `ajax.googleapis.com`). Concurrent
  calls for one version share one load (one script tag); a failed load can
  be retried.
- `package:tekartik_jquery/jquery.dart`: the `jQuery` getter (throws
  `StateError` until jQuery is in the page, or when it is older than 2.1.4),
  `jQuerySelector` / `jQuerySelectorAll` (`$(selector)`), `jElement` /
  `jElementList` (wrap `package:web` elements), the `JElement` and
  `JElementList` wrappers (`hide`, `show`, `fadeIn`, `fadeOut`,
  `querySelector` = jQuery `find`, `element`, `callMethod`), `jsObject` (the
  jQuery object, a `JSObject`).

`callMethod('attr', ['id'])` converts its Dart arguments (String, num, bool,
null, Map, List; JS values such as elements are passed as is) and returns a
String, int, double or bool as a Dart value, undefined as null, and any other
result as a JS value: `JElementList(jDiv.callMethod('children') as JSObject)`.

## Pitfalls

- The asset url is relative (`packages/...`): the page must be served from
  the root of the build (`webdev serve web`), not from a sub folder.
- `jQuerySelector('#none')` never returns null: its `element` is null and
  its `length` 0.
- `list[i]` of a `JElementList` is the raw `web.Element`; `first` is a
  `JElement`.
- A Dart function is not converted by `callMethod`: pass `fn.toJS` (a
  `JSFunction`) for jQuery callbacks.

## Migrating from 0.3.x (dart:html / dart:js)

- `JsObject` (dart:js) became `JSObject` (dart:js_interop): `jsObject` of the
  wrappers and of `JQuery`, `jsElement`, `jsDocument`, `jsQuery`.
- `dart:html` `Element` became `package:web` `Element`: `jElement`,
  `JElement.fromElement`, `jElementList`, `element`, `list[i]`. A dart:html
  element can still be passed as `(element as JSObject) as web.Element`
  (dart2js only, checked); better, create the elements with `package:web`.
- `callMethod` returns JS objects as `JSObject` (not `JsObject`), and no
  longer wraps Dart functions.

## Example

`web/kitchen_sink.html` (and its `kitchen_sink.dart`): fades with the jQuery
of the page. `test/` holds browser tests (`dart test -p chrome`, dart2js and
dart2wasm, see `dart_test.yaml`).
