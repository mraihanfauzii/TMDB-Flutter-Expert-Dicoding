import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  // Contoh MovieDetail 45m => '45m'
  const testMovieDetail45 = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 123,
    originalTitle: 'Original Title 45',
    overview: 'Overview sample 45',
    posterPath: '/poster45.jpg',
    releaseDate: '2022-01-01',
    runtime: 45,
    title: 'Test Movie 45',
    voteAverage: 7.5,
    voteCount: 100,
  );

  // Contoh MovieDetail 125m => '2h 5m'
  const testMovieDetail125 = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 2, name: 'Drama')],
    id: 999,
    originalTitle: 'Original Title 125',
    overview: 'Overview sample 125',
    posterPath: '/poster125.jpg',
    releaseDate: '2022-02-02',
    runtime: 125,
    title: 'Test Movie 125',
    voteAverage: 8.1,
    voteCount: 200,
  );

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  group('MovieDetailPage Tests', () {
    testWidgets('Displays progress when state is Loading', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loading);
      // stub data agar null-safety aman
      when(mockNotifier.movie).thenReturn(testMovieDetail45);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays error text when state is Error', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Error);
      when(mockNotifier.message).thenReturn('Error occurred');
      when(mockNotifier.movie).thenReturn(testMovieDetail45);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Watchlist button should display add icon when movie not added', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail45);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 45)));
      await tester.pump();

      // cek runtime "45m"
      expect(find.text('45m'), findsOneWidget);
      // cek icon add
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Watchlist button should display check icon when movie is watchlisted', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail125);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 125)));
      await tester.pump();

      // cek runtime "2h 5m"
      expect(find.text('2h 5m'), findsOneWidget);
      // cek icon check
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Should show Snackbar when add to watchlist success', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn(
        MovieDetailNotifier.watchlistAddSuccessMessage,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(MovieDetailNotifier.watchlistAddSuccessMessage), findsOneWidget);
    });

    testWidgets('Should show Snackbar when remove from watchlist success', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);
      when(mockNotifier.watchlistMessage).thenReturn(
        MovieDetailNotifier.watchlistRemoveSuccessMessage,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(MovieDetailNotifier.watchlistRemoveSuccessMessage), findsOneWidget);
    });

    testWidgets('Should show AlertDialog when watchlistMessage is other error', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Unexpected Error');

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Unexpected Error'), findsOneWidget);
    });

    testWidgets('Should display recommendation error text if recommendationState is Error', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail45);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
      when(mockNotifier.message).thenReturn('Recommendation Error');
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
      await tester.pump();

      expect(find.text('Recommendation Error'), findsOneWidget);
    });

    testWidgets('Should display recommendation loading if recommendationState is Loading', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail45);
      when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));

      // Karena CachedNetworkImage juga menampilkan CircularProgressIndicator
      // sebagai placeholder, total bisa 2:
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });
  });

  testWidgets('Shows 0m when runtime is 0', (tester) async {
    final zeroRuntimeMovie = testMovieDetail.copyWith(runtime: 0);

    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(zeroRuntimeMovie);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn([]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 999)));
    await tester.pump();

    expect(find.text('0m'), findsOneWidget);
  });

  testWidgets('Shows recommended items if recommendations is not empty', (tester) async {
    const recommendedMovie = Movie(
      id: 10,
      title: 'Rec Movie',
      posterPath: '/rec.jpg',
      overview: 'Recommendation overview',
      backdropPath: '',
      voteAverage: 5.0,
      voteCount: 50,
      adult: false,
      originalTitle: 'Rec Original',
      releaseDate: '2021-07-07',
      genreIds: [12],
      popularity: 77.7,
      video: false,
    );

    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(testMovieDetail45);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn([recommendedMovie]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
    await tester.pump();

    // Pastikan 'Recommendations' label
    expect(find.text('Recommendations'), findsOneWidget);

    // Pastikan kita menampilkan poster dari '/rec.jpg'
    // => Cari CachedNetworkImage dengan imageUrl: '.../rec.jpg'
    expect(
      find.byWidgetPredicate((widget) =>
      widget is CachedNetworkImage && widget.imageUrl.endsWith('/rec.jpg'),
      ),
      findsOneWidget,
    );
  });
}

extension MovieDetailCopy on MovieDetail {
  MovieDetail copyWith({
    bool? adult,
    String? backdropPath,
    List<Genre>? genres,
    int? id,
    String? originalTitle,
    String? overview,
    String? posterPath,
    String? releaseDate,
    int? runtime,
    String? title,
    double? voteAverage,
    int? voteCount,
  }) {
    return MovieDetail(
      adult: adult ?? this.adult,
      backdropPath: backdropPath ?? this.backdropPath,
      genres: genres ?? this.genres,
      id: id ?? this.id,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      releaseDate: releaseDate ?? this.releaseDate,
      runtime: runtime ?? this.runtime,
      title: title ?? this.title,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
    );
  }
}
