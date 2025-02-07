import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_state.dart';
import 'package:movie/presentation/pages/now_playing_movies_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'now_playing_movies_page_test.mocks.dart';

@GenerateMocks([NowPlayingMoviesBloc])
void main() {
  late MockNowPlayingMoviesBloc mockBloc;

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  setUp(() {
    mockBloc = MockNowPlayingMoviesBloc();
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: [1],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1,
    posterPath: '/poster.jpg',
    releaseDate: '2022-01-01',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );
  final tMovies = <Movie>[tMovie];

  testWidgets('should display CircularProgressIndicator when loading', (tester) async {
    final testState = NowPlayingMoviesState(state: RequestState.Loading, movies: [], message: '');
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<NowPlayingMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded', (tester) async {
    final testState = NowPlayingMoviesState(state: RequestState.Loaded, movies: tMovies, message: '');
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<NowPlayingMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });
}
