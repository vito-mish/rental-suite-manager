import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_suite_manager/screens/auth/login_screen.dart';

void main() {
  testWidgets('Login screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Rental Suite Manager'), findsOneWidget);
    expect(find.text('Manage smarter, rent easier.'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('登入'), findsOneWidget);
    expect(find.text('註冊'), findsOneWidget);
    expect(find.text('忘記密碼？'), findsOneWidget);
  });
}
