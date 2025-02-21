import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/presentation/widgets/episode_card.dart';

void main() {
  group('EpisodeCard Tests', () {
    final tEpisode = EpisodeModel(
      airDate: '2023-01-01',
      episodeNumber: 3,
      episodeType: '',
      id: 777,
      name: 'FooBar Episode',
      overview: 'Overview FooBar',
      runtime: 55,
      seasonNumber: 1,
      showId: 999,
      stillPath: '/stillFoo.jpg',
      voteAverage: 7.8,
      voteCount: 42,
    );

    testWidgets('Menampilkan data episode dengan benar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EpisodeCard(episode: tEpisode),
          ),
        ),
      );
      await tester.pump();

      // Cek number + name
      expect(find.text('3  FooBar Episode'), findsOneWidget);
      // Cek overview
      expect(find.text('Overview FooBar'), findsOneWidget);
      // Cek button 'Rate it!'
      expect(find.text('Rate it!'), findsOneWidget);
      // Cek image
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('Tombol "Rate it!" di-tap', (tester) async {
      var rateButtonPressed = false;

      // Buat testable widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EpisodeCard(
              episode: tEpisode,
            ),
          ),
        ),
      );
      await tester.pump();

      final rateItFinder = find.text('Rate it!');
      expect(rateItFinder, findsOneWidget);

      await tester.tap(rateItFinder);
      await tester.pump();
    });
  });
}
