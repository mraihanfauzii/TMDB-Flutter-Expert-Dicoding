import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;

  WatchlistTvBloc({required this.getWatchlistTvs})
    : super(const WatchlistTvState()) {
    on<FetchWatchlistTv>(_onFetchWatchlistTv);
  }

  Future<void> _onFetchWatchlistTv(
    FetchWatchlistTv event,
    Emitter<WatchlistTvState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.Error, message: failure.message),
        );
      },
      (tvs) {
        emit(state.copyWith(state: RequestState.Loaded, tvs: tvs));
      },
    );
  }
}
