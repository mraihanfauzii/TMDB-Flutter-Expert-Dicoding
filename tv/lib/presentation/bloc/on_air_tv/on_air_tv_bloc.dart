import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_on_air_tvs.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_event.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_state.dart';
import 'package:core/utils/state_enum.dart';

class OnAirTvBloc extends Bloc<OnAirTvEvent, OnAirTvState> {
  final GetOnAirTvs getOnAirTvs;

  OnAirTvBloc({required this.getOnAirTvs}) : super(const OnAirTvState()) {
    on<FetchOnAirTv>(_onFetchOnAirTv);
  }

  Future<void> _onFetchOnAirTv(
      FetchOnAirTv event, Emitter<OnAirTvState> emit) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getOnAirTvs.execute();
    result.fold(
      (failure) => emit(
          state.copyWith(state: RequestState.Error, message: failure.message)),
      (tvs) => emit(state.copyWith(state: RequestState.Loaded, tvs: tvs)),
    );
  }
}
