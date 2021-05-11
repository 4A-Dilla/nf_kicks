// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:nf_kicks/models/order.dart';

void main() {
  group('Test Order.fromMap()', () {
    test('test with null data', () {
      final order = Order.fromMap(null, 'documentId');
      expect(order, null);
    });
  });
}
