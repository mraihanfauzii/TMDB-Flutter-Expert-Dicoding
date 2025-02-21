import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUpAll(() {
    registerFallbackValue(FetchWatchlistMovies());
  });

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );
  final tMovieList = <Movie>[tMovie];

  // BLoC coverage
  group('WatchlistMovieBloc test', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'emits [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(state: RequestState.Loading),
        WatchlistMovieState(state: RequestState.Loaded, movies: tMovieList),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'emits [Loading, Error] when data fetch fails',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure("Can't get data")));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMovieState(state: RequestState.Loading),
        const WatchlistMovieState(
          state: RequestState.Error,
          message: "Can't get data",
        ),
      ],
    );
  });

  // Event coverage
  group('WatchlistMovieEvent coverage', () {
    test('FetchWatchlistMovies props', () {
      final event = FetchWatchlistMovies();
      expect(event.props, []);
    });
  });

  // State coverage
  group('WatchlistMovieState coverage', () {
    test('supports value equality', () {
      expect(const WatchlistMovieState(), const WatchlistMovieState());
    });

    test('props test', () {
      const state = WatchlistMovieState();
      expect(state.props, [
        RequestState.Empty,
        <Movie>[],
        '',
      ]);
    });

    test('copyWith test', () {
      final updated = const WatchlistMovieState().copyWith(
        state: RequestState.Loaded,
        movies: tMovieList,
        message: 'some error',
      );
      expect(updated.state, RequestState.Loaded);
      expect(updated.movies, tMovieList);
      expect(updated.message, 'some error');
    });
  });
}
