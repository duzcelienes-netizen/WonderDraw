import 'package:flutter_test/flutter_test.dart';
import 'package:wonderdraw/main.dart';
import 'package:wonderdraw/screens/canvas_screen.dart';

void main() {
  testWidgets(
    'WonderDrawApp acilir ve cizim tuvali gorunur',
    (WidgetTester tester) async {
      await tester.pumpWidget(const WonderDrawApp());
      await tester.pumpAndSettle();

      expect(find.byType(CanvasScreen), findsOneWidget);
      expect(find.text('✨ Canlandır ✨'), findsOneWidget);
    },
  );
}
