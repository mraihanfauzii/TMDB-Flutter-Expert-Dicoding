import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/utils.dart'; // atau route_observer.dart jika terpisah

void main() {
  test('routeObserver is a RouteObserver<ModalRoute>', () {
    expect(routeObserver, isA<RouteObserver<ModalRoute>>());
  });
}
