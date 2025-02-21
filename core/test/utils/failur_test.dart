import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/failure.dart';

void main() {
  test('ServerFailure props', () {
    const failure = ServerFailure('Server failed');
    expect(failure.message, 'Server failed');
    expect(failure.props, ['Server failed']);
  });

  test('ConnectionFailure props', () {
    const failure = ConnectionFailure('No connection');
    expect(failure.message, 'No connection');
    expect(failure.props, ['No connection']);
  });

  test('DatabaseFailure props', () {
    const failure = DatabaseFailure('DB fail');
    expect(failure.message, 'DB fail');
    expect(failure.props, ['DB fail']);
  });
}
