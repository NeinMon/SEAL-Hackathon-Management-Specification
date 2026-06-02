import 'package:flutter_test/flutter_test.dart';

import 'package:seal_hackathon_app/main.dart';

void main() {
  testWidgets('requires Supabase configuration', (WidgetTester tester) async {
    await tester.pumpWidget(const SealApp());

    expect(find.text('Cần kết nối Supabase'), findsOneWidget);
    expect(
      find.textContaining('không còn chạy bằng dữ liệu mock'),
      findsOneWidget,
    );
  });
}
