import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_state.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';

class MockSeasonDetailBloc extends Mock implements SeasonDetailBloc {}

class FakeSeasonDetailState extends Fake implements SeasonDetailState {}

void main() {
  late MockSeasonDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSeasonDetailState());
  });

  setUp(() {
    mockBloc = MockSeasonDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  final tEpisode = EpisodeModel(
    airDate: '2023-01-01',
    episodeNumber: 1,
    episodeType: '',
    id: 101,
    name: 'Episode 1',
    overview: 'Overview ep 1',
    runtime: 60,
    seasonNumber: 1,
    showId: 999,
    stillPath: '/still.jpg',
    voteAverage: 8.5,
    voteCount: 100,
  );

  group('SeasonDetailPage tests', () {
    testWidgets('Menampilkan CircularProgressIndicator ketika state Loading',
            (tester) async {
          const state = SeasonDetailState(state: RequestState.Loading);
          when(() => mockBloc.state).thenReturn(state);

          whenListen(
            mockBloc,
            Stream.value(state),
            initialState: state,
          );

          await tester.pumpWidget(
            makeTestableWidget(const SeasonDetailPage(tvId: 999, seasonNumber: 1)),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('Menampilkan ListView episode saat state Loaded & episode != 0',
            (tester) async {
          final loadedState = SeasonDetailState(
            state: RequestState.Loaded,
            episodes: [tEpisode],
          );
          when(() => mockBloc.state).thenReturn(loadedState);
          whenListen(
            mockBloc,
            Stream.value(loadedState),
            initialState: loadedState,
          );

          await tester.pumpWidget(
            makeTestableWidget(const SeasonDetailPage(tvId: 999, seasonNumber: 1)),
          );
          await tester.pump();

          // Periksa widget ListView:
          expect(find.byType(ListView), findsOneWidget);

          // Karena EpisodeCard menampilkan judul "1  Episode 1" (ada dua spasi)
          expect(find.text('1  Episode 1'), findsOneWidget);

          // Atau bisa pakai textContaining('Episode 1') jika sekadar substring.
          // expect(find.textContaining('Episode 1'), findsOneWidget);
        });

    testWidgets('Menampilkan text "No episodes found." jika episodes kosong',
            (tester) async {
          const loadedState = SeasonDetailState(
            state: RequestState.Loaded,
            episodes: [],
          );
          when(() => mockBloc.state).thenReturn(loadedState);
          whenListen(
            mockBloc,
            Stream.value(loadedState),
            initialState: loadedState,
          );

          await tester.pumpWidget(
            makeTestableWidget(const SeasonDetailPage(tvId: 999, seasonNumber: 1)),
          );
          await tester.pump();

          expect(find.text('No episodes found.'), findsOneWidget);
        });

    testWidgets('Menampilkan error message jika state Error', (tester) async {
      const errorState = SeasonDetailState(
        state: RequestState.Error,
        message: 'Error season detail',
      );
      when(() => mockBloc.state).thenReturn(errorState);
      whenListen(
        mockBloc,
        Stream.value(errorState),
        initialState: errorState,
      );

      await tester.pumpWidget(
        makeTestableWidget(const SeasonDetailPage(tvId: 999, seasonNumber: 1)),
      );
      await tester.pump();

      expect(find.text('Error season detail'), findsOneWidget);
    });
  });
}
