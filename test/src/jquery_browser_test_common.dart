import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:pub_semver/pub_semver.dart';
import 'package:tekartik_jquery/jquery.dart';
import 'package:tekartik_js_utils_interop/object_keys.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

web.HTMLDivElement _div({String? id, String? className, String? test}) {
  var element = web.HTMLDivElement();
  if (id != null) {
    element.id = id;
  }
  if (className != null) {
    element.className = className;
  }
  if (test != null) {
    element.setAttribute('test', test);
  }
  return element;
}

/// The tests of a jQuery [version] loaded by [load] ([jquery2]: jQuery 2,
/// whose objects also have a context).
void jqueryBrowserTests({
  required Future<void> Function() load,
  required Version version,
  bool jquery2 = false,
}) {
  setUp(() async {
    await load();
  });

  group('Global', () {
    test('version', () {
      expect(jQuery!.version! >= jQueryVersionMin, isTrue);
      expect(jQuery!.version, version);
    });

    test('map', () {
      expect(jQuery!.fn('jquery'), jQuery!.version.toString());
    });
  });

  group('JElement', () {
    test('element', () {
      var element = _div();
      var jDiv = jElement(element)!;
      expect(element, jDiv.element);
    });
    test('call method', () {
      var element = _div();

      var jDiv = jElement(element)!;

      expect(jDiv.callMethod('attr', ['id']), null);
      element.id = 'my_id';
      expect(jDiv.callMethod('attr', ['id']), 'my_id');
      // Dart results: bool, int; a jQuery object stays a JS object.
      expect(jDiv.callMethod('is', ['div']), isTrue);
      expect(jDiv.callMethod('index'), -1);
      expect(jDiv.callMethod('children'), isNotNull);
      expect(JElementList(jDiv.callMethod('children') as JSObject).length, 0);
    });
    test('querySelector', () {
      expect(jQuerySelector('body')!.element, web.document.body);
      expect(jQuerySelector('nobody')!.element, null);
    });
  });

  group('JElementList', () {
    test('empty', () {
      var list = JElementList.empty();
      expect(list.length, 0);
    });
    test('elements', () {
      var element = _div();
      var element2 = _div();
      var list = jElementList([element, element2]);
      expect(list.length, 2);
      expect(element, list[0]);
      expect(element2, list[1]);
      expect(list[2], isNull);
    });

    test('querySelector', () {
      expect(jQuerySelectorAll('body').length, 1);
      expect(jQuerySelectorAll('body').first.element, web.document.body);
    });

    test('querySelector in a container', () {
      var element = _div(id: 'my_id', className: 'my-class', test: 'value1');
      var element2 = _div(id: 'my_id2', className: 'my-class', test: 'value2');

      var container = _div()
        ..append(element)
        ..append(element2);
      var jContainer = jElement(container)!;
      var list = jContainer.querySelectorAll('.my-class');
      expect(list.length, 2);
      expect(list[0], element);
      expect(list[1], element2);

      expect(jContainer.querySelector('.my-class').element, element);

      list = jContainer.querySelectorAll('#my_id2');
      expect(list.length, 1);
      expect(list[0], element2);

      expect(jContainer.querySelector('#my_id2').element, element2);
    });
  });

  group('JObjectElement', () {
    test('id and attr', () {
      var element = _div(id: 'my_id', test: 'value1');
      var jDiv = jElement(element)!;
      expect(jDiv.id, 'my_id');
      expect(jDiv.element!.getAttribute('test'), 'value1');
    });

    test('jsObject', () {
      var element = _div(id: 'my_id', test: 'value1');
      var jDiv = jElement(element)!;
      var jsObject = jDiv.jsObject;
      // {0: div, length: 1}, jQuery 2 adds context: div
      expect(jsObjectKeys(jsObject), ['0', if (jquery2) 'context', 'length']);
      expect(jsObject['0'], element);
      expect(jsObject.getProperty<web.Element>(0.toJS), element);
      expect((jsObject['length'] as JSNumber).toDartInt, 1);
      if (jquery2) {
        expect(jsObject['context'], element);
      }
    });
  });

  group('effects', () {
    test('hide show fade', () {
      var element = _div();
      web.document.body!.append(element);
      try {
        var jDiv = jElement(element)!;
        jDiv.hide();
        expect(element.style.display, 'none');
        jDiv.show();
        expect(element.style.display, isNot('none'));
        jDiv.fadeOut(FadeDuration.withDuration(0));
        jDiv.fadeIn(FadeDuration.fast);
      } finally {
        element.remove();
      }
    });
  });
}
