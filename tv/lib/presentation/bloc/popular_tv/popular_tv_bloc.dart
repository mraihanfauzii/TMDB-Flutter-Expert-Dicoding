import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';
import 'package:core/utils/state_enum.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvs getPopularTvs;

  PopularTvBloc({required this.getPopularTvs}) : super(const PopularTvState()) {
    on<FetchPopularTv>(_onFetchPopularTv);
  }

  Future<void> _onFetchPopularTv(
    FetchPopularTv event,
    Emitter<PopularTvState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (tvs) => emit(state.copyWith(state: RequestState.Loaded, tvs: tvs)),
    );
  }
}
