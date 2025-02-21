import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/exception.dart';

void main() {
  test('ServerException can be thrown', () {
    expect(() => throw ServerException(), throwsA(isA<ServerException>()));
  });

  test('DatabaseException has correct message', () {
    var exception = DatabaseException('DB Error');
    expect(exception.message, 'DB Error');
  });
}
