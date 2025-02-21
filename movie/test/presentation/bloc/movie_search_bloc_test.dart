import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_state.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUpAll(() {
    registerFallbackValue(const FetchMovieSearch('dummy'));
  });

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  const tQuery = 'spiderman';
  final tMovies = <Movie>[
    const Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: '2023-01-01',
      title: 'Title',
      video: false,
      voteAverage: 8.0,
      voteCount: 100,
    )
  ];

  // BLoC coverage
  group('MovieSearchBloc test', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Loaded] when search is successful',
      build: () {
        when(() => mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        MovieSearchState(state: RequestState.Loaded, movies: tMovies),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(() => mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => const Left(ServerFailure('Error search')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        const MovieSearchState(state: RequestState.Error, message: 'Error search'),
      ],
    );
  });

  // Event coverage
  group('MovieSearchEvent coverage', () {
    test('FetchMovieSearch props', () {
      const event = FetchMovieSearch('kraven');
      expect(event.props, ['kraven']);
    });
  });

  // State coverage
  group('MovieSearchState coverage', () {
    test('supports value equality', () {
      expect(const MovieSearchState(), const MovieSearchState());
    });

    test('props test', () {
      const state = MovieSearchState();
      expect(state.props, [
        RequestState.Empty,
        <Movie>[],
        '',
      ]);
    });

    test('copyWith test', () {
      final updated = const MovieSearchState().copyWith(
        state: RequestState.Loaded,
        movies: tMovies,
        message: 'some error',
      );
      expect(updated.state, RequestState.Loaded);
      expect(updated.movies, tMovies);
      expect(updated.message, 'some error');
    });
  });
}
