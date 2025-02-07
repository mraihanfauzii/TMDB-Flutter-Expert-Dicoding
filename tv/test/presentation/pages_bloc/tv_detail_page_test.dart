import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailBloc])
void main() {
  late MockTvDetailBloc mockBloc;

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

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
    testWidgets('shows loading indicator when tvState is Loading', (tester) async {
      final testState = TvDetailState(
        tvState: RequestState.Loading,
        message: '',
        recommendations: [],
        isAddedToWatchlist: false,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([testState]),
        initialState: testState,
      );
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error text when tvState is Error', (tester) async {
      final testState = TvDetailState(
        tvState: RequestState.Error,
        message: 'Error occurred',
        recommendations: [],
        isAddedToWatchlist: false,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([testState]),
        initialState: testState,
      );
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('displays detail content when data is loaded', (tester) async {
      final testState = TvDetailState(
        tvState: RequestState.Loaded,
        tvDetail: testTvDetail,
        message: '',
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: false,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([testState]),
        initialState: testState,
      );
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();
      expect(find.text('Test Tv'), findsOneWidget);
      expect(find.text('Overview test'), findsOneWidget);
      expect(find.text('Season 1'), findsOneWidget);
    });

    testWidgets('displays check icon when isAddedWatchlist is true', (tester) async {
      final testState = TvDetailState(
        tvState: RequestState.Loaded,
        tvDetail: testTvDetail,
        message: '',
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: true,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([testState]),
        initialState: testState,
      );
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays add icon when isAddedWatchlist is false', (tester) async {
      final testState = TvDetailState(
        tvState: RequestState.Loaded,
        tvDetail: testTvDetail,
        message: '',
        recommendationState: RequestState.Loaded,
        recommendations: [],
        isAddedToWatchlist: false,
      );
      when(mockBloc.state).thenReturn(testState);
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([testState]),
        initialState: testState,
      );
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
