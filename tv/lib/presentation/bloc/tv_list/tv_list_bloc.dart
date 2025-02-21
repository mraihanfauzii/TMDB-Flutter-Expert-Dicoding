import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_on_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnAirTvs getOnAirTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  TvListBloc({
    required this.getOnAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(const TvListState()) {
    on<FetchTvList>(_onFetchTvList);
  }

  Future<void> _onFetchTvList(
    FetchTvList event,
    Emitter<TvListState> emit,
  ) async {
    // Set semua kategori ke Loading
    emit(
      state.copyWith(
        onAirState: RequestState.Loading,
        popularState: RequestState.Loading,
        topRatedState: RequestState.Loading,
      ),
    );

    // On Air TVs
    final onAirResult = await getOnAirTvs.execute();
    onAirResult.fold(
      (failure) {
        emit(
          state.copyWith(
            onAirState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (onAirTvs) {
        emit(
          state.copyWith(onAirState: RequestState.Loaded, onAirTvs: onAirTvs),
        );
      },
    );

    // Popular TVs
    final popularResult = await getPopularTvs.execute();
    popularResult.fold(
      (failure) {
        emit(
          state.copyWith(
            popularState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (popularTvs) {
        emit(
          state.copyWith(
            popularState: RequestState.Loaded,
            popularTvs: popularTvs,
          ),
        );
      },
    );

    // Top Rated TVs
    final topRatedResult = await getTopRatedTvs.execute();
    topRatedResult.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (topRatedTvs) {
        emit(
          state.copyWith(
            topRatedState: RequestState.Loaded,
            topRatedTvs: topRatedTvs,
          ),
        );
      },
    );
  }
}
