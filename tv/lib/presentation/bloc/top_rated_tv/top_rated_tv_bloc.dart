import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_event.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_state.dart';
import 'package:core/utils/state_enum.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvBloc({required this.getTopRatedTvs})
    : super(const TopRatedTvState()) {
    on<FetchTopRatedTv>(_onFetchTopRatedTv);
  }

  Future<void> _onFetchTopRatedTv(
    FetchTopRatedTv event,
    Emitter<TopRatedTvState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (tvs) => emit(state.copyWith(state: RequestState.Loaded, tvs: tvs)),
    );
  }
}
