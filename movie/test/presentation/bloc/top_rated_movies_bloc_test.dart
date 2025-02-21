import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_event.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_state.dart';

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late TopRatedMoviesBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUpAll(() {
    registerFallbackValue(FetchTopRatedMovies());
  });

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview top rated',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: '2023-01-01',
    title: 'Top Rated Title',
    video: false,
    voteAverage: 8.1,
    voteCount: 100,
  );
  final tMovies = <Movie>[tMovie];

  // BLoC coverage
  group('TopRatedMoviesBloc test', () {
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [Loading, Loaded] when get top rated success',
      build: () {
        when(() => mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const TopRatedMoviesState(state: RequestState.Loading),
        TopRatedMoviesState(state: RequestState.Loaded, movies: tMovies),
      ],
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [Loading, Error] when get top rated fails',
      build: () {
        when(() => mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Failed top rated')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const TopRatedMoviesState(state: RequestState.Loading),
        const TopRatedMoviesState(
          state: RequestState.Error,
          message: 'Failed top rated',
        ),
      ],
    );
  });

  // Event coverage
  group('TopRatedMoviesEvent coverage', () {
    test('FetchTopRatedMovies props', () {
      final event = FetchTopRatedMovies();
      expect(event.props, []);
    });
  });

  // State coverage
  group('TopRatedMoviesState coverage', () {
    test('supports value equality', () {
      expect(const TopRatedMoviesState(), const TopRatedMoviesState());
    });

    test('props test', () {
      const state = TopRatedMoviesState();
      expect(state.props, [
        RequestState.Empty,
        <Movie>[],
        '',
      ]);
    });

    test('copyWith test', () {
      final updated = const TopRatedMoviesState().copyWith(
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
