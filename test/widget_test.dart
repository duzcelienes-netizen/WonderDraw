// Bu dosya, `flutter create` tarafından üretilen ve olmayan bir "MyApp"
// sınıfına referans veren örnek şablonun yerine, WonderDraw'ın gerçek giriş
// noktasına (WonderDrawApp) uygun, minimal bir duman testidir (smoke test).
//
// Amaç: uygulamanın hatasız açıldığını ve doğrudan çizim tuvaline geldiğini
// (splash/menü olmadan) doğrulamak. Herhangi bir animasyon/davranış detayına
// girmiyor — WonderDraw mimarisi bu testin kapsamı dışında.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wonderdraw/main.dart';
import 'package:wonderdraw/screens/canvas_screen.dart';

void main() {
  testWidgets('WonderDrawApp acilir ve dogrudan cizim tuvaline gelir',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WonderDrawApp());
    await tester.pumpAndSettle();

    // PRD ilkesi: hiçbir splash/menü/login ekranı yok — uygulama doğrudan
    // CanvasScreen ile açılır.
    expect(find.byType(CanvasScreen), findsOneWidget);

    // "✨ Canlandır" butonu ekran ağacında var (henüz çizim yokken opaklığı
    // animasyonla sıfırlanır, ama widget kaldırılmaz) — burada sadece
    // ekranın çökmeden kurulduğunu doğruluyoruz.
    expect(find.text('✨ Canlandır ✨'), findsOneWidget);
  });
}
