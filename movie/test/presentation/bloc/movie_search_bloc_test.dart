import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  const tQuery = 'spiderman';
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2],
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

  group('FetchMovieSearch', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Loaded] when search is successful',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        MovieSearchState(state: RequestState.Loaded, movies: tMovieList),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        const MovieSearchState(state: RequestState.Error, message: 'Error'),
      ],
    );
  });
}
