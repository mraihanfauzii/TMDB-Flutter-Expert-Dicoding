import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
      FetchMovieDetail event, Emitter<MovieDetailState> emit) async {
    emit(state.copyWith(movieState: RequestState.Loading));
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult =
        await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          movieState: RequestState.Error,
          message: failure.message,
        ));
      },
      (movie) async {
        emit(state.copyWith(
          movieDetail: movie,
          movieState: RequestState.Loaded,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (movies) {
            emit(state.copyWith(
              recommendations: movies,
              recommendationState: RequestState.Loaded,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddWatchlist(
      AddWatchlist event, Emitter<MovieDetailState> emit) async {
    final result = await saveWatchlist.execute(event.movie);
    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );
    add(LoadWatchlistStatus(event.movie.id));
  }

  Future<void> _onRemoveWatchlist(
      RemoveFromWatchlist event, Emitter<MovieDetailState> emit) async {
    final result = await removeWatchlist.execute(event.movie);
    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );
    add(LoadWatchlistStatus(event.movie.id));
  }

  Future<void> _onLoadWatchlistStatus(
      LoadWatchlistStatus event, Emitter<MovieDetailState> emit) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
