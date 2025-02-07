import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_state.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockBloc;

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
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
    final testState = PopularMoviesState(state: RequestState.Loading, movies: [], message: '');
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded', (tester) async {
    final testState = PopularMoviesState(state: RequestState.Loaded, movies: tMovies, message: '');
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error', (tester) async {
    final testState = PopularMoviesState(state: RequestState.Error, movies: [], message: 'Error message');
    when(mockBloc.state).thenReturn(testState);
    whenListen(
      mockBloc,
      Stream<PopularMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
    expect(find.text('Error message'), findsOneWidget);
  });
}
