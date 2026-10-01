import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_biometrico_app/main.dart';

void main() {
  testWidgets('Teste de Inicialização do App Ponto Biométrico', (WidgetTester tester) async {
    await tester.pumpWidget(const PontoBiometricoApp());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
