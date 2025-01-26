import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Flow: go to TV Series -> search "squid game" -> tap detail -> tap season 1',
        (tester) async {
      // 1. Jalankan aplikasi
      app.main();

      // 2. Tunggu build
      await tester.pumpAndSettle();

      // 3. Tap bottom nav "TV Series"
      final tvSeriesNav = find.text('TV Series');
      expect(tvSeriesNav, findsOneWidget);
      await tester.tap(tvSeriesNav);
      await tester.pumpAndSettle();

      // 4. Tap icon search (di AppBar)
      final searchIcon = find.byIcon(Icons.search);
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      // 5. Ketik "squid game" di TextField, submit
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'squid game');
      // Tekan "enter"/"search"
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // 6. Tunggu hasil, tap item pertama (tvSearchResult0)
      final firstSearchResult = find.byKey(const Key('tvSearchResult0'));
      await tester.ensureVisible(firstSearchResult);
      expect(firstSearchResult, findsOneWidget);

      await tester.tap(firstSearchResult);
      await tester.pumpAndSettle();

      // 7. Scroll detail (opsional) - DraggableScrollableSheet
      await tester.drag(find.byType(DraggableScrollableSheet), const Offset(0, -200));
      await tester.pumpAndSettle();

      // 8. Tap "Season 1"
      final seasonOneText = find.text('Season 1');
      await tester.ensureVisible(seasonOneText);
      expect(seasonOneText, findsOneWidget);

      await tester.tap(seasonOneText);
      await tester.pumpAndSettle();

      // 9. Verifikasi di season detail menampilkan Judul Episode
      final episodesTitle = find.textContaining('Red Light, Green Light');
      expect(episodesTitle, findsWidgets);
    },
  );
}