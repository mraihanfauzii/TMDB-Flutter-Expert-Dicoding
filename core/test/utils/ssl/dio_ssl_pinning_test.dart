import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/ssl/dio_ssl_pinning.dart';
import 'package:dio/dio.dart';

void main() {
  // Pastikan binding Flutter ter-inisialisasi sebelum test
  TestWidgetsFlutterBinding.ensureInitialized();

  test('createDioWithSSLPinning returns a Dio instance', () async {
    final dio = await createDioWithSSLPinning();
    expect(dio, isA<Dio>());
  });
}
