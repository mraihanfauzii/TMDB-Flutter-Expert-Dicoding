import 'package:core/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('init should not throw', () async {
    try {
      await di.init();
    } catch (e, stack) {
      fail('init() threw an exception: $e\n$stack');
    }
    di.locator.allReady();
    expect(true, true);
  });
}
