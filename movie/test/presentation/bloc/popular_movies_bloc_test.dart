import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_event.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_state.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late PopularMoviesBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUpAll(() {
    registerFallbackValue(FetchPopularMovies());
  });

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);
  });

  final tMovies = <Movie>[
    const Movie(
      adult: false,
      backdropPath: 'path',
      genreIds: [1],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'poster',
      releaseDate: '2023-01-01',
      title: 'Title',
      video: false,
      voteAverage: 8.0,
      voteCount: 100,
    )
  ];

  // BLoC coverage
  group('PopularMoviesBloc test', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        PopularMoviesState(state: RequestState.Loaded, movies: tMovies),
      ],
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetPopularMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Error Popular')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        const PopularMoviesState(state: RequestState.Error, message: 'Error Popular'),
      ],
    );
  });

  // Event coverage
  group('PopularMoviesEvent coverage', () {
    test('FetchPopularMovies props', () {
      final event = FetchPopularMovies();
      expect(event.props, []);
    });
  });

  // State coverage
  group('PopularMoviesState coverage', () {
    test('supports value equality', () {
      expect(const PopularMoviesState(), const PopularMoviesState());
    });

    test('props test', () {
      const state = PopularMoviesState();
      expect(state.props, [
        RequestState.Empty,
        <Movie>[],
        '',
      ]);
    });

    test('copyWith test', () {
      final updated = const PopularMoviesState().copyWith(
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
