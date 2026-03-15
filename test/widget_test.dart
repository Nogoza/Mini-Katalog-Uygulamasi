
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CatalogApp());

    // Verify that our app bar title exists.
    expect(find.text('Mini Katalog'), findsOneWidget);
  });
}
