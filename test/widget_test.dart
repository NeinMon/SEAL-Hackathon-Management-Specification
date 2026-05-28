import 'package:flutter_test/flutter_test.dart';

import 'package:seal_hackathon_app/main.dart';

void main() {
  testWidgets('requires Supabase configuration', (WidgetTester tester) async {
    await tester.pumpWidget(const SealApp());

    expect(find.text('Supabase connection required'), findsOneWidget);
    expect(
      find.textContaining('no longer runs with mock data'),
      findsOneWidget,
    );
  });
}
