import 'package:flutter_test/flutter_test.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/settings_controller.dart';

void main() {
  testWidgets('News app loads successfully', (WidgetTester tester) async {
    final settingsController = SettingsController();

    await tester.pumpWidget(
      NewsApp(settingsController: settingsController),
    );

    // Verify that the app builds and displays its MaterialApp.
    expect(find.byType(NewsApp), findsOneWidget);

    settingsController.dispose();
  });
}