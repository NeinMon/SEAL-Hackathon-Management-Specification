import 'package:flutter_test/flutter_test.dart';

import 'package:seal_hackathon_app/main.dart';

void main() {
  testWidgets('requires Supabase configuration', (WidgetTester tester) async {
    await tester.pumpWidget(const SealApp());

    expect(find.text('Không thể kết nối hệ thống'), findsOneWidget);
    expect(
      find.textContaining('Ứng dụng chưa sẵn sàng để tải dữ liệu'),
      findsOneWidget,
    );
  });
}
