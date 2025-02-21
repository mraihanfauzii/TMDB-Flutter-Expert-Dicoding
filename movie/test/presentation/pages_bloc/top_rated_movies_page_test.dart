import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_state.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedMoviesBloc extends Mock implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
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
    final testState = TopRatedMoviesState(state: RequestState.Loading, movies: [], message: '');
    when(() => mockBloc.state).thenReturn(testState);
    whenListen<TopRatedMoviesState>(
      mockBloc,
      Stream<TopRatedMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded', (tester) async {
    final testState = TopRatedMoviesState(state: RequestState.Loaded, movies: tMovies, message: '');
    when(() => mockBloc.state).thenReturn(testState);
    whenListen<TopRatedMoviesState>(
      mockBloc,
      Stream<TopRatedMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error', (tester) async {
    final testState = TopRatedMoviesState(state: RequestState.Error, movies: [], message: 'Error message');
    when(() => mockBloc.state).thenReturn(testState);
    whenListen<TopRatedMoviesState>(
      mockBloc,
      Stream<TopRatedMoviesState>.fromIterable([testState]),
      initialState: testState,
    );
    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));
    expect(find.text('Error message'), findsOneWidget);
  });
}
