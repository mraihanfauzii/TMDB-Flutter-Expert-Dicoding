import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies})
      : super(const MovieSearchState()) {
    on<FetchMovieSearch>(_onFetchMovieSearch);
  }

  Future<void> _onFetchMovieSearch(
      FetchMovieSearch event, Emitter<MovieSearchState> emit) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await searchMovies.execute(event.query);
    result.fold(
      (failure) {
        emit(state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ));
      },
      (moviesData) {
        emit(state.copyWith(
          state: RequestState.Loaded,
          movies: moviesData,
        ));
      },
    );
  }
}
