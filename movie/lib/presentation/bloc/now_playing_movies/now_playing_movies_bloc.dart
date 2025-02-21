import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_event.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc({required this.getNowPlayingMovies})
    : super(const NowPlayingMoviesState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<NowPlayingMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.Error, message: failure.message),
        );
      },
      (moviesData) {
        emit(state.copyWith(state: RequestState.Loaded, movies: moviesData));
      },
    );
  }
}
