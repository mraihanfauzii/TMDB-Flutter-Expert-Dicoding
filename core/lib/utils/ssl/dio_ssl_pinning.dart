import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Dio> createDioWithSSLPinning() async {
  final dio = Dio();

  final certData = await rootBundle.load(
    'assets/certificates/certificates.pem',
  );
  final Uint8List bytes = certData.buffer.asUint8List();

  final SecurityContext sc = SecurityContext(withTrustedRoots: false);
  sc.setTrustedCertificatesBytes(bytes);

  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (
    HttpClient client,
  ) {
    client = HttpClient(context: sc);
    client.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) {
      return false;
    };
    return client;
  };

  return dio;
}
