import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListTvStatus getWatchListTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(const TvDetailState()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddWatchlistTv>(_onAddWatchlistTv);
    on<RemoveWatchlistTvEvent>(_onRemoveWatchlistTv);
    on<LoadWatchlistTvStatus>(_onLoadWatchlistTvStatus);
  }

  Future<void> _onFetchTvDetail(
      FetchTvDetail event, Emitter<TvDetailState> emit) async {
    emit(state.copyWith(tvState: RequestState.Loading));
    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
            tvState: RequestState.Error, message: failure.message));
      },
      (tv) async {
        emit(state.copyWith(tvDetail: tv, tvState: RequestState.Loaded));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
                recommendationState: RequestState.Error,
                message: failure.message));
          },
          (tvs) {
            emit(state.copyWith(
                recommendationState: RequestState.Loaded,
                recommendations: tvs));
          },
        );
      },
    );
  }

  Future<void> _onAddWatchlistTv(
      AddWatchlistTv event, Emitter<TvDetailState> emit) async {
    final result = await saveWatchlistTv.execute(event.tv);
    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );
    add(LoadWatchlistTvStatus(event.tv.id));
  }

  Future<void> _onRemoveWatchlistTv(
      RemoveWatchlistTvEvent event, Emitter<TvDetailState> emit) async {
    final result = await removeWatchlistTv.execute(event.tv);
    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );
    add(LoadWatchlistTvStatus(event.tv.id));
  }

  Future<void> _onLoadWatchlistTvStatus(
      LoadWatchlistTvStatus event, Emitter<TvDetailState> emit) async {
    final result = await getWatchListTvStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
