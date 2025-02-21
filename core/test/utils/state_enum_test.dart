import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/state_enum.dart';

void main() {
  test('RequestState values check', () {
    // Memastikan ke-4 nilai
    expect(RequestState.values, [
      RequestState.Empty,
      RequestState.Loading,
      RequestState.Loaded,
      RequestState.Error,
    ]);
    // Indeks
    expect(RequestState.Empty.index, 0);
    expect(RequestState.Loading.index, 1);
    expect(RequestState.Loaded.index, 2);
    expect(RequestState.Error.index, 3);
  });
}
