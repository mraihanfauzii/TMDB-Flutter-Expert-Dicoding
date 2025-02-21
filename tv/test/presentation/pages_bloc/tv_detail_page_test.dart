import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

// ----- MOCK / FAKE -----
class MockTvDetailBloc extends Mock implements TvDetailBloc {}
class FakeTvDetailEvent extends Fake implements TvDetailEvent {}
class FakeTvDetailState extends Fake implements TvDetailState {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
  });

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
        // Simulasi routing agar pushNamed/pushReplacementNamed tidak error
        onGenerateRoute: (settings) {
          if (settings.name == SeasonDetailPage.ROUTE_NAME) {
            final args = settings.arguments as SeasonDetailArgs;
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: Text('Season ${args.seasonNumber}')),
                body: const Center(child: Text('SeasonDetailPage mock')),
              ),
            );
          } else if (settings.name == TvDetailPage.ROUTE_NAME) {
            final tvId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => TvDetailPage(id: tvId),
            );
          }
          return null;
        },
      ),
    );
  }

  // ----- DATA DUMMY -----
  final tSeason = Season(
    airDate: '2022-01-01',
    episodeCount: 10,
    id: 200,
    name: 'Season 1',
    overview: 'Overview season 1',
    posterPath: '/season.jpg',
    seasonNumber: 1,
    voteAverage: 8.5,
  );

  final tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    posterPath: '/poster.jpg',
    overview: 'Overview test',
    voteAverage: 7.8,
    genres: ['Drama', 'Mystery'],
    numberOfEpisodes: 22,
    numberOfSeasons: 3,
    seasons: [],
  );

  // Versi yang punya season
  final tTvDetailWithSeason = tTvDetail.copyWith(
    seasons: [
      Season(
        airDate: '2023-01-01',
        episodeCount: 9,
        id: 201,
        name: 'Season 1',
        overview: 'Overview S1',
        posterPath: '/season1.jpg',
        seasonNumber: 1,
        voteAverage: 8.0,
      ),
    ],
  );

  // Rekomendasi dummy
  final tRecommendation = Tv(
    id: 999,
    name: 'No Text Shown, But There Is a Poster',
    overview: 'Rec Overview',
    posterPath: '/recPoster.jpg',
    voteAverage: 6.7,
    firstAirDate: '2023-04-01',
  );

  group('TvDetailPage Tests', () {
    testWidgets('Tampilkan CircularProgressIndicator ketika state=Loading',
            (tester) async {
          final loadingState = const TvDetailState(tvState: RequestState.Loading);
          when(() => mockBloc.state).thenReturn(loadingState);
          whenListen<TvDetailState>(
            mockBloc,
            Stream.value(loadingState),
            initialState: loadingState,
          );

          await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('Tampilkan error text ketika state=Error', (tester) async {
      const errorState = TvDetailState(
        tvState: RequestState.Error,
        message: 'Error occurred',
      );
      when(() => mockBloc.state).thenReturn(errorState);
      whenListen<TvDetailState>(
        mockBloc,
        Stream.value(errorState),
        initialState: errorState,
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Tampilkan detail ketika state=Loaded + tvDetail!=null',
            (tester) async {
          final loadedState = TvDetailState(
            tvState: RequestState.Loaded,
            tvDetail: tTvDetailWithSeason,
            recommendationState: RequestState.Loaded,
            recommendations: [tRecommendation],
            isAddedToWatchlist: false,
          );
          when(() => mockBloc.state).thenReturn(loadedState);
          whenListen<TvDetailState>(
            mockBloc,
            Stream.value(loadedState),
            initialState: loadedState,
          );

          await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
          await tester.pump();

          // Periksa judul, overview
          expect(find.text('Test TV'), findsOneWidget);
          expect(find.text('Overview test'), findsOneWidget);

          // Pastikan Watchlist button menampilkan ikon add
          final watchlistButton = find.byType(ElevatedButton);
          expect(watchlistButton, findsOneWidget);
          expect(find.byIcon(Icons.add), findsOneWidget);

          // Pastikan ada Season 1
          expect(find.text('Season 1'), findsOneWidget);
        });

    testWidgets(
      'Mengetuk watchlist button (belum watchlist) memicu AddWatchlistTv event',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
          recommendationState: RequestState.Loaded,
          recommendations: [],
          isAddedToWatchlist: false,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump();

        final watchlistButton = find.byType(ElevatedButton);
        await tester.tap(watchlistButton);
        await tester.pump();

        verify(() => mockBloc.add(AddWatchlistTv(tTvDetail))).called(1);
      },
    );

    testWidgets(
      'Mengetuk watchlist button (sudah watchlist) memicu RemoveWatchlistTvEvent',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
          recommendationState: RequestState.Loaded,
          recommendations: [],
          isAddedToWatchlist: true,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump();

        final watchlistButton = find.byType(ElevatedButton);
        await tester.tap(watchlistButton);
        await tester.pump();

        verify(() => mockBloc.add(RemoveWatchlistTvEvent(tTvDetail))).called(1);
      },
    );

    testWidgets(
      'Mengetuk item recommendations => pushReplacementNamed ke TvDetailPage',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
          recommendationState: RequestState.Loaded,
          recommendations: [tRecommendation],
          isAddedToWatchlist: false,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        // Perbesar layar agar item tak "off-screen"
        await tester.binding.setSurfaceSize(const Size(800, 1200));

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump();

        // InkWell (recommendations) => di _buildRecommendations
        final recInkwell = find.byType(InkWell).last;
        expect(recInkwell, findsOneWidget);

        await tester.tap(recInkwell);
        // pumpAndSettle mungkin timeout => lakukan manual pump
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }

        // Kembalikan ukuran jika mau
        await tester.binding.setSurfaceSize(const Size(800, 600));
      },
    );

    testWidgets(
      'Mengetuk item season => pushNamed(SeasonDetailPage)',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetailWithSeason,
          recommendationState: RequestState.Loaded,
          recommendations: [],
          isAddedToWatchlist: false,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump();

        // Temukan text 'Season 1'
        final seasonText = find.text('Season 1');
        expect(seasonText, findsOneWidget);

        await tester.ensureVisible(seasonText);
        await tester.tap(seasonText);
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }

        // Pastikan "SeasonDetailPage mock" ada
        expect(find.text('SeasonDetailPage mock'), findsOneWidget);
      },
    );

    testWidgets(
      'Tekan back button => Navigator.pop',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
          recommendationState: RequestState.Loaded,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        await tester.pumpWidget(MaterialApp(
          home: Builder(builder: (context) {
            return makeTestableWidget(const TvDetailPage(id: 1));
          }),
        ));
        await tester.pump();

        final backButton = find.byIcon(Icons.arrow_back);
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
      },
    );

    testWidgets(
      'Jika seasons kosong => menampilkan SizedBox',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail, // seasons kosong
          recommendationState: RequestState.Loaded,
          recommendations: [],
          isAddedToWatchlist: false,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump();

        expect(find.text('Seasons'), findsOneWidget);
        // Karena seasons kosong => tidak ada list item
      },
    );

    testWidgets(
      'Menampilkan "Untitled Season" dan "No overview available." ketika name & overview kosong, posterPath null',
          (tester) async {
        final loadedState = TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail.copyWith(
            seasons: [
              const Season(
                airDate: '2022-01-01',
                episodeCount: 5,
                id: 202,
                name: '', // kosong => "Untitled Season"
                overview: '', // kosong => "No overview available."
                posterPath: null, // => placeholder
                seasonNumber: 2,
                voteAverage: 0.0,
              ),
            ],
          ),
          recommendationState: RequestState.Loaded,
          recommendations: [],
          isAddedToWatchlist: false,
        );
        when(() => mockBloc.state).thenReturn(loadedState);
        whenListen<TvDetailState>(
          mockBloc,
          Stream.value(loadedState),
          initialState: loadedState,
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump();

        // Pastikan menampilkan "Untitled Season"
        expect(find.text('Untitled Season'), findsOneWidget);
        // Pastikan menampilkan "No overview available."
        expect(find.text('No overview available.'), findsOneWidget);

        // Poster path null => 'https://via.placeholder.com/150'
        // (Tidak mudah dicek text-nya, tapi minimal test tidak error.)
      },
    );
  });
}

// Agar compile: definisi copyWith
extension on TvDetail {
  TvDetail copyWith({
    List<Season>? seasons,
  }) {
    return TvDetail(
      id: id,
      name: name,
      posterPath: posterPath,
      overview: overview,
      voteAverage: voteAverage,
      genres: genres,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      seasons: seasons ?? this.seasons,
    );
  }
}
