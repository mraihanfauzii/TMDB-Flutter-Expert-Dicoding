import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

class MockMovieDetailBloc extends Mock implements MovieDetailBloc {}
class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}
class FakeMovieDetailState extends Fake implements MovieDetailState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute<T> extends Fake implements Route<T> {}

void main() {
  late MockMovieDetailBloc mockBloc;
  late MockNavigatorObserver mockObserver;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeRoute<dynamic>());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        routes: {
          MovieDetailPage.ROUTE_NAME: (ctx) {
            final args = ModalRoute.of(ctx)!.settings.arguments as int;
            return Scaffold(
              appBar: AppBar(title: Text('Dummy detail page: $args')),
              body: const Center(child: Text('This is a mocked next page')),
            );
          },
        },
        home: body,
        navigatorObservers: [mockObserver],
      ),
    );
  }

  setUp(() {
    mockBloc = MockMovieDetailBloc();
    mockObserver = MockNavigatorObserver();
  });

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

  final tRecommendation = Movie(
    adult: false,
    backdropPath: '/recomBackdrop.jpg',
    genreIds: [12],
    id: 777,
    originalTitle: 'Recommendation Title',
    overview: 'Recom Overview',
    popularity: 50,
    posterPath: '/recomPoster.jpg',
    releaseDate: '2022-03-03',
    title: 'Recom Title',
    video: false,
    voteAverage: 6.0,
    voteCount: 99,
  );

  group('MovieDetailPage Tests', () {
    testWidgets('Displays progress indicator when state is Loading', (tester) async {
      final testState = const MovieDetailState(movieState: RequestState.Loading);
      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      // Ditemukan 2 CircularProgressIndicator (1 untuk poster placeholder, 1 untuk body)
      // => kita cek minimal 1
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('Displays error text when state is Error', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Error,
        message: 'Error occurred',
      );
      when(() => mockBloc.state).thenReturn(testState);
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
      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
      await tester.pump();

      expect(find.text('45m'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Overview sample 45'), findsOneWidget);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Watchlist button shows check icon when movie is watchlisted', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail125,
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: true,
      );
      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 999)));
      await tester.pump();

      expect(find.text('2h 5m'), findsOneWidget);
      expect(find.text('Drama'), findsOneWidget);
      expect(find.text('Overview sample 125'), findsOneWidget);

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Shows SnackBar when add to watchlist success', (tester) async {
      final initialState = MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loaded,
        recommendations: const [],
        isAddedToWatchlist: false,
        watchlistMessage: '',
      );
      final newState = initialState.copyWith(
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: true,
      );
      when(() => mockBloc.state).thenReturn(newState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([initialState, newState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      // SnackBar muncul
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets('Shows SnackBar when remove from watchlist success', (tester) async {
      final initialState = MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail125,
        recommendationState: RequestState.Loaded,
        recommendations: const [],
        isAddedToWatchlist: true,
        watchlistMessage: '',
      );
      final newState = initialState.copyWith(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: false,
      );
      when(() => mockBloc.state).thenReturn(newState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([initialState, newState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 999)));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });

    testWidgets('Shows AlertDialog when watchlistMessage is neither "Added..." nor "Removed..."', (tester) async {
      final initialState = MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loaded,
        recommendations: const [],
        isAddedToWatchlist: false,
        watchlistMessage: '',
      );
      final newState = initialState.copyWith(watchlistMessage: 'DB Error');
      when(() => mockBloc.state).thenReturn(newState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([initialState, newState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('DB Error'), findsOneWidget);
    });

    testWidgets('Shows recommendations loading indicator when recommendationState is Loading', (tester) async {
      final testState = MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loading,
        recommendations: const [],
        isAddedToWatchlist: false,
      );

      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
      await tester.pump();

      // Pastikan kita menemukan widget CircularProgressIndicator dengan key 'recommendation_loading'
      final loadingIndicator = find.byKey(const Key('recommendation_loading'));
      expect(loadingIndicator, findsOneWidget);
    });

    testWidgets('Shows recommendations error text when recommendationState is Error', (tester) async {
      final testState = MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail125,
        recommendationState: RequestState.Error,
        message: 'Recommendation Error',
        recommendations: const [],
        isAddedToWatchlist: false,
      );
      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 999)));
      await tester.pump();

      expect(find.text('Recommendation Error'), findsOneWidget);
    });

    testWidgets('Tapping recommendation item calls Navigator.pushReplacementNamed', (tester) async {
      // Perbesar ukuran layar uji agar item tidak "off-screen"
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      final recommendations = [tRecommendation];
      final testState = MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loaded,
        recommendations: recommendations,
        isAddedToWatchlist: false,
      );

      // Stub bloc
      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      // Bangun widget
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
      await tester.pump();

      // Pastikan item #0 ada
      final recKey0 = find.byKey(const Key('recommendation_item_0'));
      expect(recKey0, findsOneWidget);

      // Tap item
      await tester.tap(recKey0);
      await tester.pumpAndSettle();

      // Verifikasi pushReplacementNamed
      verify(() => mockObserver.didPush(any(), any())).called(1);

      // (Opsional) Kembalikan ukuran layar ke default (jika diperlukan)
      await tester.binding.setSurfaceSize(const Size(800, 600));
    });

    testWidgets('Tapping back button => Navigator.pop', (tester) async {
      final testState = const MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail45,
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: false,
      );
      when(() => mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<MovieDetailState>.fromIterable([testState]),
        initialState: testState,
      );

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 123)));
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPop(any(), any())).called(1);
    });
  });
}
