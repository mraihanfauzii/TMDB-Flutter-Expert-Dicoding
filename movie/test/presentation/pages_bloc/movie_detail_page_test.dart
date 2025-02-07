import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;

  // Fungsi untuk membuat widget uji dengan BlocProvider
  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  // Contoh data dummy
  const testMovieDetail45 = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 123,
    originalTitle: 'Original Title 45',
    overview: 'Overview sample 45',
    posterPath: '/poster45.jpg',
    releaseDate: '2022-01-01',
    runtime: 45, // akan ditampilkan sebagai "45m"
    title: 'Test Movie 45',
    voteAverage: 7.5,
    voteCount: 100,
  );

  const testMovieDetail125 = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 2, name: 'Drama')],
    id: 999,
    originalTitle: 'Original Title 125',
    overview: 'Overview sample 125',
    posterPath: '/poster125.jpg',
    releaseDate: '2022-02-02',
    runtime: 125, // akan ditampilkan sebagai "2h 5m"
    title: 'Test Movie 125',
    voteAverage: 8.1,
    voteCount: 200,
  );

  group('MovieDetailPage Bloc Tests', () {
    setUp(() {
      mockBloc = MockMovieDetailBloc();
    });

    testWidgets('Displays progress indicator when state is Loading', (tester) async {
      final testState = const MovieDetailState(movieState: RequestState.Loading);
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays error text when state is Error', (tester) async {
      final testState = const MovieDetailState(movieState: RequestState.Error, message: 'Error occurred');
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Watchlist button shows add icon when movie is not watchlisted', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: false,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 45)));
      await tester.pump();

      // Asumsikan fungsi konversi runtime menghasilkan "45m"
      expect(find.text('45m'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Watchlist button shows check icon when movie is watchlisted', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail125,
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: true,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 125)));
      await tester.pump();

      // Asumsikan fungsi konversi runtime menghasilkan "2h 5m"
      expect(find.text('2h 5m'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Shows SnackBar when add to watchlist success', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: false,
        watchlistMessage: 'Added to Watchlist',
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      // Simulasikan ketukan pada tombol watchlist (yang merupakan ElevatedButton atau FilledButton)
      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump(); // pump untuk menampilkan SnackBar

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets('Shows SnackBar when remove from watchlist success', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail125,
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: true,
        watchlistMessage: 'Removed from Watchlist',
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 125)));
      await tester.pump();

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });
  });
}
