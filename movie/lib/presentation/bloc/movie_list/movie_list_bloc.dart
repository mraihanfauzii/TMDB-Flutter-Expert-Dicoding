import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<MovieListState> emit,
  ) async {
    // Pertama, set semua state ke Loading
    emit(
      state.copyWith(
        nowPlayingState: RequestState.Loading,
        popularState: RequestState.Loading,
        topRatedState: RequestState.Loading,
      ),
    );

    // Fetch Now Playing
    final nowPlayingResult = await getNowPlayingMovies.execute();
    nowPlayingResult.fold(
      (failure) {
        emit(
          state.copyWith(
            nowPlayingState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (nowPlayingMovies) {
        emit(
          state.copyWith(
            nowPlayingState: RequestState.Loaded,
            nowPlayingMovies: nowPlayingMovies,
          ),
        );
      },
    );

    // Fetch Popular
    final popularResult = await getPopularMovies.execute();
    popularResult.fold(
      (failure) {
        emit(
          state.copyWith(
            popularState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (popularMovies) {
        emit(
          state.copyWith(
            popularState: RequestState.Loaded,
            popularMovies: popularMovies,
          ),
        );
      },
    );

    // Fetch Top Rated
    final topRatedResult = await getTopRatedMovies.execute();
    topRatedResult.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (topRatedMovies) {
        emit(
          state.copyWith(
            topRatedState: RequestState.Loaded,
            topRatedMovies: topRatedMovies,
          ),
        );
      },
    );
  }
}
