import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_state.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockNowPlaying;
  late MockGetPopularMovies mockPopular;
  late MockGetTopRatedMovies mockTopRated;

  setUp(() {
    mockNowPlaying = MockGetNowPlayingMovies();
    mockPopular = MockGetPopularMovies();
    mockTopRated = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockNowPlaying,
      getPopularMovies: mockPopular,
      getTopRatedMovies: mockTopRated,
    );
  });

  const tMovie = Movie(
    adult: false,
    backdropPath: 'path',
    genreIds: [1, 2],
    id: 1,
    originalTitle: 'OriginalTitle',
    overview: 'overview',
    popularity: 10.0,
    posterPath: 'poster',
    releaseDate: '2023-01-01',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );
  final tMovieList = <Movie>[tMovie];

  group('FetchMovies', () {
    // 1) Semua sukses
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading -> nowPlaying Loaded -> popular Loaded -> topRated Loaded] (semua sukses)',
      build: () {
        when(mockNowPlaying.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockPopular.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockTopRated.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovies()),
      expect: () => [
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedState: RequestState.Loaded,
          topRatedMovies: tMovieList,
        ),
      ],
    );

    // 2) Now Playing error, lainnya sukses
    blocTest<MovieListBloc, MovieListState>(
      'emits nowPlaying Error, lalu popular & topRated sukses',
      build: () {
        when(mockNowPlaying.execute())
            .thenAnswer((_) async => const Left(ServerFailure('NowPlaying fail')));
        when(mockPopular.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockTopRated.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovies()),
      expect: () => [
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        const MovieListState(
          nowPlayingState: RequestState.Error,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
          message: 'NowPlaying fail',
        ),
        MovieListState(
          nowPlayingState: RequestState.Error,
          popularState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedState: RequestState.Loading,
          message: 'NowPlaying fail',
        ),
        MovieListState(
          nowPlayingState: RequestState.Error,
          popularState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedState: RequestState.Loaded,
          topRatedMovies: tMovieList,
          message: 'NowPlaying fail',
        ),
      ],
    );

    // 3) Popular error, NowPlaying & TopRated sukses
    blocTest<MovieListBloc, MovieListState>(
      'emits popular Error, sementara nowPlaying & topRated sukses',
      build: () {
        when(mockNowPlaying.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockPopular.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Popular fail')));
        when(mockTopRated.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovies()),
      expect: () => [
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Error,
          topRatedState: RequestState.Loading,
          message: 'Popular fail',
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Error,
          topRatedState: RequestState.Loaded,
          topRatedMovies: tMovieList,
          message: 'Popular fail',
        ),
      ],
    );

    // 4) TopRated error, NowPlaying & Popular sukses
    blocTest<MovieListBloc, MovieListState>(
      'emits topRated Error, sementara nowPlaying & popular sukses',
      build: () {
        when(mockNowPlaying.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockPopular.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockTopRated.execute())
            .thenAnswer((_) async => const Left(ServerFailure('TopRated fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovies()),
      expect: () => [
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedState: RequestState.Loading,
        ),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedState: RequestState.Error,
          message: 'TopRated fail',
        ),
      ],
    );

    group('MovieListEvent coverage', () {
      test('FetchMovies props', () {
        final event = FetchMovies();
        expect(event.props, []);
      });
    });

    group('MovieListState coverage', () {
      test('supports value equality', () {
        expect(const MovieListState(), const MovieListState());
      });

      test('props test', () {
        const state = MovieListState();
        expect(state.props, [
          [], // nowPlayingMovies
          RequestState.Empty, // nowPlayingState
          [], // popularMovies
          RequestState.Empty, // popularState
          [], // topRatedMovies
          RequestState.Empty, // topRatedState
          '', // message
        ]);
      });

      test('copyWith test', () {
        final updatedState = const MovieListState().copyWith(
          nowPlayingMovies: tMovieList,
          nowPlayingState: RequestState.Loaded,
          popularMovies: tMovieList,
          popularState: RequestState.Loaded,
          topRatedMovies: tMovieList,
          topRatedState: RequestState.Loaded,
          message: 'some message',
        );
        expect(updatedState.nowPlayingMovies, tMovieList);
        expect(updatedState.nowPlayingState, RequestState.Loaded);
        expect(updatedState.popularMovies, tMovieList);
        expect(updatedState.popularState, RequestState.Loaded);
        expect(updatedState.topRatedMovies, tMovieList);
        expect(updatedState.topRatedState, RequestState.Loaded);
        expect(updatedState.message, 'some message');
      });
    });
  });
}
