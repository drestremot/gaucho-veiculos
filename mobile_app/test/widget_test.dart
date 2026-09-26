import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaucho_veiculos/main.dart';

void main() {
  testWidgets('Gaucho Veiculos app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GauchoVeiculosApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
