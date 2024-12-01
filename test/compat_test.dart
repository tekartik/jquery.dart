import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_jquery/src/export.dart';
import 'package:test/test.dart';

void main() {
  test('compat', () {
    expect(isJQuerySupported, kDartIsWeb);
  });
}
