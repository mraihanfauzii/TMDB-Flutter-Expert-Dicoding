import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  const testTvDetail = TvDetail(
    id: 1,
    name: 'Test Tv',
    posterPath: '/path.jpg',
    overview: 'Overview test',
    voteAverage: 8.0,
    genres: ['Drama'],
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
    seasons: [
      Season(
        airDate: '2021-09-17',
        episodeCount: 9,
        id: 999,
        name: 'Season 1',
        overview: 'Overview season 1',
        posterPath: '/season1.jpg',
        seasonNumber: 1,
        voteAverage: 8.2,
      ),
      Season(
        airDate: '',
        episodeCount: 0,
        id: 1000,
        name: '',
        overview: '',
        posterPath: null,
        seasonNumber: 2,
        voteAverage: 0.0,
      ),
    ],
  );

  group('TvDetailPage Tests', () {
    setUp(() {
      mockNotifier = MockTvDetailNotifier();
    });

    testWidgets('Shows loading when tvState is Loading', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loading);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows error text when tvState is Error', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Error);
      when(mockNotifier.message).thenReturn('Error occurred');

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Displays detail content when data is loaded', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Test Tv'), findsOneWidget);
      expect(find.text('Overview test'), findsOneWidget);
      expect(find.text('Seasons'), findsOneWidget);
      expect(find.text('Season 1'), findsOneWidget); // from the season object
    });

    testWidgets('Displays check icon when isAddedWatchlist = true', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Displays add icon when isAddedWatchlist = false', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Tap watchlist button => add watchlist success snackBar', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage)
          .thenReturn(TvDetailNotifier.watchlistAddSuccessMessage);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(TvDetailNotifier.watchlistAddSuccessMessage), findsOneWidget);
    });

    testWidgets('Tap watchlist button => remove watchlist success snackBar', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);
      when(mockNotifier.watchlistMessage)
          .thenReturn(TvDetailNotifier.watchlistRemoveSuccessMessage);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(TvDetailNotifier.watchlistRemoveSuccessMessage), findsOneWidget);
    });

    testWidgets('Tap watchlist button => error => show dialog', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Error from DB');

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error from DB'), findsOneWidget);
    });

    testWidgets('Should display recommendations label if recommendations not empty', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([
        const Tv(
          id: 2,
          name: 'Recommended Tv',
          overview: 'Some overview',
          posterPath: null,
          voteAverage: 7.2,
          firstAirDate: '2022-01-01',
        ),
      ]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Recommendations'), findsOneWidget);
    });

    testWidgets('no recommendations => empty widget', (tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.tvRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      // Checking if "Recommendations" text is still displayed but no item
      expect(find.text('Recommendations'), findsOneWidget);
    });
  });
}
