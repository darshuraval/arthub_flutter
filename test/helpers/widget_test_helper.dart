import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget with MaterialApp and Scaffold for testing
Widget wrapWithMaterialApp(Widget widget) {
  return MaterialApp(
    home: Scaffold(
      body: widget,
    ),
  );
}

/// Pumps a widget wrapped with MaterialApp and Scaffold
Future<void> pumpWrappedWidget(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(wrapWithMaterialApp(widget));
}

/// Finds a widget by key and verifies it exists exactly once
Finder findOneWidget(Key key) {
  final finder = find.byKey(key);
  expect(finder, findsOneWidget);
  return finder;
}

/// Verifies text exists exactly once
void expectTextPresent(String text) {
  expect(find.text(text), findsOneWidget);
}

/// Verifies a widget of type T exists exactly once
void expectWidgetPresent<T extends Widget>() {
  expect(find.byType(T), findsOneWidget);
}

/// Taps a widget and pumps the tester
Future<void> tapAndPump(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pump();
}

/// Enters text in a TextField and pumps the tester
Future<void> enterTextAndPump(WidgetTester tester, String text, {Finder? finder}) async {
  await tester.enterText(finder ?? find.byType(TextField), text);
  await tester.pump();
}

/// Creates a mock callback function and returns both the function and a way to verify it was called
typedef Callback = void Function();
(Callback callback, void Function() verify) createCallbackWithVerification() {
  bool called = false;
  return (
    () => called = true,
    () => expect(called, isTrue, reason: 'Callback should have been called'),
  );
} 