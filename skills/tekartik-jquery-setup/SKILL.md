---
name: tekartik-jquery-setup
description: >-
  Use when Dart web code drives jQuery through package:tekartik_jquery
  (dart:js_interop + package:web, dart2js and dart2wasm): the jQuery
  global and its version check (jQueryVersionMin, jQueryVersionDefault,
  jQueryVersion2Default, jQueryVersion3Min), loadJQuery / loadCdnJQuery from
  jquery_loader.dart, jQuerySelector, jQuerySelectorAll, jElement,
  jElementList, jsElement, jsDocument, the JElement / JElementList /
  JObjectBase / JObjectWithElement / JList wrappers, hide, show, fadeIn,
  fadeOut with FadeDuration.slow / FadeDuration.withDuration, and the
  tekartik_jquery_asset script paths.
---

# tekartik_jquery: jQuery wrapper (tekartik_jquery)

`tekartik_jquery` is a thin Dart wrapper around the jQuery JavaScript library,
built on `dart:js_interop` and `package:web` (`JSObject`, `web.Element`): it
runs in a browser compiled with dart2js or dart2wasm, never on the VM. Until
0.3.x it was `dart:html` + `dart:js` (`JsObject`, dart2js only).

## Guidelines

* Dependency (git only, not published on pub.dev). It pulls
  `tekartik_jquery_asset` (the bundled jQuery files), `tekartik_browser_utils`,
  `tekartik_js_utils_interop`, `tekartik_common_utils` and `web`:
  ```yaml
  dependencies:
    tekartik_jquery:
      git:
        url: https://github.com/tekartik/jquery.dart
  ```
* Two public libraries:
  * `package:tekartik_jquery/jquery.dart` — the API: the `jQuery` global,
    selectors, element wrappers and effects (it re-exports `JElement`,
    `JElementList`, `JObjectBase`, `JObjectWithElement`, `JList`,
    `FadeDuration`).
  * `package:tekartik_jquery/jquery_loader.dart` — `Future<JQuery?>
    loadJQuery({Version? version})` and `Future<JQuery?>
    loadCdnJQuery({Version? version})` (`Version` from `package:pub_semver`).
* jQuery must be present in the page **before** any call. Either add a
  `<script>` tag (`packages/tekartik_jquery_asset/3.1.1/jquery.min.js`, or
  `packages/tekartik_jquery_asset/2.1.4/jquery-2.1.4.min.js` for the 2.x
  layout), or `await loadJQuery()` in `main()` before touching anything else.
  `loadCdnJQuery()` fetches
  `//ajax.googleapis.com/ajax/libs/jquery/<version>/jquery.min.js` instead.
* Versions: `jQueryVersionDefault` and `jQueryVersion3Min` are `3.1.1`,
  `jQueryVersion2Default` and `jQueryVersionMin` are `2.1.4`. `loadJQuery()`
  with no argument loads `jQueryVersionDefault`; pass
  `version: jQueryVersion2Default` for the 2.x asset. Both loaders return the
  already-loaded `jQuery` (and throw `StateError` if the loaded version is
  older than the one asked for) when `jQuery` is already in the page.
  Otherwise they add a `<script>` tag. Concurrent calls for the same version
  share one pending load (one script tag, since 0.4.0); a failed load is
  forgotten, the next call retries.
* `jQuery` (a `JQuery?`) throws `StateError('Missing jQuery')` when the script
  is not loaded, and a `StateError` about the version when the page has less
  than `jQueryVersionMin`. Only a valid jQuery is cached (in a private global):
  it keeps throwing until the script is loaded, then works. Start with
  `await loadJQuery()`.
* Selectors and wrappers, all in `jquery.dart`:
  * `JElement? jQuerySelector(String selector)` — `$(selector)` as a single
    element wrapper. It is non-null even when nothing matches: check
    `jElement.element == null`.
  * `JElementList jQuerySelectorAll(String selector)` — same call, list view.
  * `JElement? jElement(Element element)` / `JElement.fromElement(element)` —
    wrap an existing `package:web` element (`web.Element`); `JElementList jElementList(List<web.Element>)`
    wraps several; `JElementList.empty()` is an empty set.
  * `JSObject? jsElement(web.Element)` and `JSObject? get jsDocument` return the
    raw jQuery objects (`$(element)`, `$(document)`).
* On a `JElement` / `JElementList` (mixin `JObjectWithElement`): `hide()`,
  `show()`, `fadeIn([FadeDuration])`, `fadeOut([FadeDuration])`,
  `web.Element? get element` (the first DOM element, `null` when empty),
  `String get id`, `JElement querySelector(String)` and
  `JElementList querySelectorAll(String)` (jQuery `find`, so descendants only).
  From `JObjectBase`: `jsObject`, `callMethod(String method, [List? args])`,
  `length`, `hasLength`. Anything jQuery offers that is not wrapped is one
  `callMethod` away (`jDiv.callMethod('attr', ['id'])`): Dart String, num,
  bool, null, Map and List arguments are converted (JS values passed as is,
  a Dart callback must be `fn.toJS`); a string, number or boolean result
  comes back as a Dart value, undefined as null, anything else as a JS value
  (`as JSObject`).
* `JElementList` is a `JList<web.Element>`: `list[i]` returns the raw `web.Element?`,
  while `list.first` returns a `JElement` (jQuery `first()`). `length` is the
  jQuery `length` property.
* `FadeDuration` (from `jeffects.dart`, re-exported): `FadeDuration.slow`,
  `FadeDuration.fast`, `FadeDuration.withName('slow')`,
  `FadeDuration.withDuration(2000)` (milliseconds). The uppercase `SLOW` /
  `FAST` constants are deprecated.
* Deprecated, do not use in new code: `queryElement(element)` (use
  `jsElement`), `jsQuery` (use `jQuery`), `jQueryVersion` (use
  `jQuery!.version`), `getAttr` / `setAttr` on the element mixin (use
  `element!.getAttribute`).
* Platform guard: `bool get isJQuerySupported` lives in
  `package:tekartik_jquery/src/export.dart` (an implementation import, chosen
  by a `dart.library.js_interop` conditional export) and is `true` only on the
  web. Use it in code shared with the VM.
* Tests: mark them `@TestOn('browser')`; `dart_test.yaml` lists the
  `dart2js` and `dart2wasm` compilers. Give each
  test file a custom `<html>` with the jQuery `<script>` tag when the test
  expects jQuery to be preloaded (`<link rel="x-dart-test" href="..._test.dart">`
  plus `<script src="packages/test/dart.js"></script>`). A test that calls
  `loadJQuery()` must run in a page where jQuery is *not* already present.
* Build the page with `build_runner` / `build_web_compilers`, or
  `dart compile js` / `dart compile wasm`.

## Examples

### Load jQuery then use it

```dart
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_jquery/jquery_loader.dart';

Future<void> main() async {
  // Loads packages/tekartik_jquery_asset/3.1.1/jquery.min.js (no-op if the
  // page already has jQuery). Do this before reading `jQuery`.
  await loadJQuery();
  print('jquery ${jQuery!.version}'); // 3.1.1

  jQuerySelector('#status')
    ?..hide()
    ..fadeIn(FadeDuration.slow);
}
```

### Page that ships the script tag itself

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>kitchen_sink</title>
    <script src="packages/tekartik_jquery_asset/3.1.1/jquery.min.js"></script>
  </head>
  <body>
    <p id="to_fade_in">Fading in...</p>
    <p id="to_fade_out">Fading out...</p>
    <script src="kitchen_sink.dart.js"></script>
  </body>
</html>
```

```dart
import 'package:tekartik_jquery/jquery.dart';

void main() {
  jQuerySelector('#to_fade_in')!
    ..hide()
    ..fadeIn();
  jQuerySelector('#to_fade_out')!.fadeOut(FadeDuration.withDuration(2000));
}
```

### Wrap existing elements

```dart
import 'package:tekartik_jquery/jquery.dart';
import 'package:web/web.dart' as web;

void decorate(web.Element container) {
  var jContainer = jElement(container)!;

  // jQuery find(): descendants only
  var items = jContainer.querySelectorAll('.item');
  for (var i = 0; i < (items.length ?? 0); i++) {
    var element = items[i]!; // raw web.Element
    element.classList.add('decorated');
  }

  // Anything not wrapped goes through callMethod
  jContainer.callMethod('attr', ['data-count', '${items.length}']);

  // first() as a wrapper, element as the DOM node
  print(items.first.element?.id);
}
```

### A list built from several elements

```dart
import 'package:tekartik_jquery/jquery.dart';
import 'package:web/web.dart' as web;

JElementList hideAll(List<web.Element> elements) {
  var list = elements.isEmpty ? JElementList.empty() : jElementList(elements);
  list.hide();
  return list;
}
```

### Browser test with jQuery loaded by the page

```dart
@TestOn('browser')
library;

import 'package:tekartik_jquery/jquery.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

void main() {
  group('jquery', () {
    test('version', () {
      expect(jQuery!.version! >= jQueryVersionMin, isTrue);
    });
    test('select', () {
      expect(jQuerySelector('body')!.element, web.document.body);
      expect(jQuerySelector('nobody')!.element, isNull); // no match
    });
  });
}
```

### Shared code that must also compile on the VM

```dart
// ignore: implementation_imports
import 'package:tekartik_jquery/src/export.dart';

/// true only when compiled for the web.
bool get canUseJQuery => isJQuerySupported;
```

## Common mistakes

* Reading `jQuery` before the script is loaded throws `Missing jQuery`, a
  selector fails (no `jQuery` function in the page). `await loadJQuery()`
  first.
* Importing this package from VM or Flutter native code: it is browser
  only.
* Passing a Dart closure to `callMethod`: convert it with `.toJS`.
* Expecting `jQuerySelector('#none')` to return `null`: it returns a wrapper
  whose `element` is `null` and whose `length` is 0.
* Treating `list[i]` as a `JElement`: it is a raw `web.Element?`.
* Calling `querySelector` on a wrapper to find the element itself: it maps to
  jQuery `find`, which only searches descendants.
* Mixing asset paths: `3.1.1/jquery.min.js` for 3.x,
  `2.1.4/jquery-2.1.4.min.js` for 2.x.
* Using the deprecated `jsQuery`, `queryElement`, `jQueryVersion`, `getAttr`,
  `setAttr`, `FadeDuration.SLOW` / `FadeDuration.FAST`.
