import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_event.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_state.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

void main() {
  late NowPlayingMoviesBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUpAll(() {
    registerFallbackValue(FetchNowPlayingMovies());
  });

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMoviesBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
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
  group('NowPlayingMoviesBloc test', () {
    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const NowPlayingMoviesState(state: RequestState.Loading),
        NowPlayingMoviesState(state: RequestState.Loaded, movies: tMovies),
      ],
    );

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Error Now Playing')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const NowPlayingMoviesState(state: RequestState.Loading),
        const NowPlayingMoviesState(
          state: RequestState.Error,
          message: 'Error Now Playing',
        ),
      ],
    );
  });

  // Event coverage
  group('NowPlayingMoviesEvent coverage', () {
    test('FetchNowPlayingMovies props', () {
      final event = FetchNowPlayingMovies();
      expect(event.props, []);
    });
  });

  // State coverage
  group('NowPlayingMoviesState coverage', () {
    test('supports value equality', () {
      expect(const NowPlayingMoviesState(), const NowPlayingMoviesState());
    });

    test('props test', () {
      const state = NowPlayingMoviesState();
      expect(state.props, [
        RequestState.Empty,
        <Movie>[],
        '',
      ]);
    });

    test('copyWith test', () {
      final updated = const NowPlayingMoviesState().copyWith(
        state: RequestState.Loaded,
        movies: tMovies,
        message: 'some message',
      );
      expect(updated.state, RequestState.Loaded);
      expect(updated.movies, tMovies);
      expect(updated.message, 'some message');
    });
  });
}
