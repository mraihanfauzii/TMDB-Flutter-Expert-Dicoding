import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_state.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'season_detail_page_test.mocks.dart';

@GenerateMocks([SeasonDetailBloc])
void main() {
  late MockSeasonDetailBloc mockBloc;

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  setUp(() {
    mockBloc = MockSeasonDetailBloc();
  });

  testWidgets('should display list of episodes when state is Loaded', (WidgetTester tester) async {
    final testEpisode = EpisodeModel(
      airDate: '2021-09-17',
      episodeNumber: 1,
      episodeType: 'standard',
      id: 1922715,
      name: 'Red Light, Green Light',
      overview: 'Overview ep1',
      runtime: 61,
      seasonNumber: 1,
      showId: 93405,
      stillPath: '/test.jpg',
      voteAverage: 8.262,
      voteCount: 879,
    );
    final testState = SeasonDetailState(
      state: RequestState.Loaded,
      episodes: [testEpisode],
      message: '',
    );
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<SeasonDetailState>.fromIterable([testState]),
      initialState: testState,
    );

    await tester.pumpWidget(makeTestableWidget(const SeasonDetailPage(tvId: 1, seasonNumber: 1)));
    await tester.pump();
    expect(find.text('Red Light, Green Light'), findsOneWidget);
  });

  testWidgets('should display error text when state is Error', (WidgetTester tester) async {
    final testState = SeasonDetailState(
      state: RequestState.Error,
      episodes: [],
      message: 'Error occurred',
    );
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<SeasonDetailState>.fromIterable([testState]),
      initialState: testState,
    );

    await tester.pumpWidget(makeTestableWidget(const SeasonDetailPage(tvId: 1, seasonNumber: 1)));
    await tester.pump();
    expect(find.text('Error occurred'), findsOneWidget);
  });
}
