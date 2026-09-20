---
name: tekartik-jquery-setup
description: >-
  Use when maintaining legacy Dart web code that drives jQuery through
  package:tekartik_jquery (dart:html + dart:js, dart2js only): the jQuery
  global and its version check (jQueryVersionMin, jQueryVersionDefault,
  jQueryVersion2Default, jQueryVersion3Min), loadJQuery / loadCdnJQuery from
  jquery_loader.dart, jQuerySelector, jQuerySelectorAll, jElement,
  jElementList, jsElement, jsDocument, the JElement / JElementList /
  JObjectBase / JObjectWithElement / JList wrappers, hide, show, fadeIn,
  fadeOut with FadeDuration.slow / FadeDuration.withDuration, and the
  tekartik_jquery_asset script paths.
---

# tekartik_jquery: legacy jQuery wrapper (tekartik_jquery)

`tekartik_jquery` is a thin Dart wrapper around the jQuery JavaScript library.
It is legacy code built on `dart:html` and `dart:js` (`JsObject`,
`context.callMethod('jQuery', ...)`), not on `dart:js_interop`: it only runs in
a browser compiled with **dart2js**, never on the VM and never with
dart2wasm. Use it to keep an existing page alive; write new web code with
`package:web` and `dart:js_interop` instead.

## Guidelines

* Dependency (git only, not published on pub.dev). It pulls
  `tekartik_jquery_asset` (the bundled jQuery files), `tekartik_browser_utils`,
  `tekartik_js_utils` and `tekartik_common_utils`:
  ```yaml
  dependencies:
    tekartik_jquery:
      git:
        url: https://github.com/tekartik/jquery.dart
      version: '>=0.3.0'
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
* `jQuery` (a `JQuery?`) throws `StateError('Missing jQuery')` when the script
  is not loaded, and a `StateError` about the version when the page has less
  than `jQueryVersionMin`. The result is cached in a private global on first
  access, **including a failed one**: never read `jQuery` (or `jQuery!.version`)
  before the script is loaded, or every later access keeps failing in the same
  process. Start with `await loadJQuery()`.
* Selectors and wrappers, all in `jquery.dart`:
  * `JElement? jQuerySelector(String selector)` — `$(selector)` as a single
    element wrapper. It is non-null even when nothing matches: check
    `jElement.element == null`.
  * `JElementList jQuerySelectorAll(String selector)` — same call, list view.
  * `JElement? jElement(Element element)` / `JElement.fromElement(element)` —
    wrap an existing `dart:html` element; `JElementList jElementList(List<Element>)`
    wraps several; `JElementList.empty()` is an empty set.
  * `JsObject? jsElement(Element)` and `JsObject? get jsDocument` return the
    raw `dart:js` objects (`$(element)`, `$(document)`).
* On a `JElement` / `JElementList` (mixin `JObjectWithElement`): `hide()`,
  `show()`, `fadeIn([FadeDuration])`, `fadeOut([FadeDuration])`,
  `Element? get element` (the first DOM element, `null` when empty),
  `String get id`, `JElement querySelector(String)` and
  `JElementList querySelectorAll(String)` (jQuery `find`, so descendants only).
  From `JObjectBase`: `jsObject`, `callMethod(String method, [List? args])`,
  `length`, `hasLength`. Anything jQuery offers that is not wrapped is one
  `callMethod` away (`jDiv.callMethod('attr', ['id'])`).
* `JElementList` is a `JList<Element>`: `list[i]` returns the raw `Element?`,
  while `list.first` returns a `JElement` (jQuery `first()`). `length` is the
  jQuery `length` property.
* `FadeDuration` (from `jeffects.dart`, re-exported): `FadeDuration.slow`,
  `FadeDuration.fast`, `FadeDuration.withName('slow')`,
  `FadeDuration.withDuration(2000)` (milliseconds). The uppercase `SLOW` /
  `FAST` constants are deprecated.
* Deprecated, do not use in new code: `queryElement(element)` (use
  `jsElement`), `jsQuery` (use `jQuery`), `jQueryVersion` (use
  `jQuery!.version`), `getAttr` / `setAttr` on the element mixin (use
  `element!.attributes`).
* Platform guard: `bool get isJQuerySupported` lives in
  `package:tekartik_jquery/src/export.dart` (an implementation import, chosen
  by a `dart.library.js_interop` conditional export) and is `true` only on the
  web. Use it in code shared with the VM; it is the only part of this package
  that compiles off the browser.
* Tests: mark them `@TestOn('browser && !wasm')` (`dart:html`/`dart:js` do not
  exist in wasm), pin `compilers: [dart2js]` in `dart_test.yaml`, and give each
  test file a custom `<html>` with the jQuery `<script>` tag when the test
  expects jQuery to be preloaded (`<link rel="x-dart-test" href="..._test.dart">`
  plus `<script src="packages/test/dart.js"></script>`). A test that calls
  `loadJQuery()` must run in a page where jQuery is *not* already present.
* Build the page with `build_runner` / `build_web_compilers` (dart2js); a
  `dart2wasm` build of any file importing this package fails to compile.

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

### Wrap existing dart:html elements

```dart
import 'dart:html';

import 'package:tekartik_jquery/jquery.dart';

void decorate(Element container) {
  var jContainer = jElement(container)!;

  // jQuery find(): descendants only
  var items = jContainer.querySelectorAll('.item');
  for (var i = 0; i < (items.length ?? 0); i++) {
    var element = items[i]!; // raw dart:html Element
    element.classes.add('decorated');
  }

  // Anything not wrapped goes through callMethod
  jContainer.callMethod('attr', ['data-count', '${items.length}']);

  // first() as a wrapper, element as the DOM node
  print(items.first.element?.id);
}
```

### A list built from several elements

```dart
import 'dart:html';

import 'package:tekartik_jquery/jquery.dart';

JElementList hideAll(List<Element> elements) {
  var list = elements.isEmpty ? JElementList.empty() : jElementList(elements);
  list.hide();
  return list;
}
```

### Browser test with jQuery loaded by the page

```dart
@TestOn('browser && !wasm')
library;

import 'dart:html';

import 'package:tekartik_jquery/jquery.dart';
import 'package:test/test.dart';

void main() {
  group('jquery', () {
    test('version', () {
      expect(jQuery!.version! >= jQueryVersionMin, isTrue);
    });
    test('select', () {
      expect(jQuerySelector('body')!.element, document.body);
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

* Reading `jQuery` (or any selector) before the script is loaded: the failed
  lookup is cached, so later calls keep failing. `await loadJQuery()` first.
* Compiling with dart2wasm, or importing this package from VM/Flutter code:
  `dart:html` and `dart:js` are browser + dart2js only.
* Expecting `jQuerySelector('#none')` to return `null`: it returns a wrapper
  whose `element` is `null` and whose `length` is 0.
* Treating `list[i]` as a `JElement`: it is a raw `dart:html` `Element?`.
* Calling `querySelector` on a wrapper to find the element itself: it maps to
  jQuery `find`, which only searches descendants.
* Mixing asset paths: `3.1.1/jquery.min.js` for 3.x,
  `2.1.4/jquery-2.1.4.min.js` for 2.x.
* Using the deprecated `jsQuery`, `queryElement`, `jQueryVersion`, `getAttr`,
  `setAttr`, `FadeDuration.SLOW` / `FadeDuration.FAST`.
