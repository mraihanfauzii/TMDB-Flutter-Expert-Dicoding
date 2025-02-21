import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_event.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_state.dart';

class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final TvRemoteDataSource remoteDataSource;

  SeasonDetailBloc({required this.remoteDataSource})
    : super(const SeasonDetailState()) {
    on<FetchSeasonDetail>(_onFetchSeasonDetail);
  }

  Future<void> _onFetchSeasonDetail(
    FetchSeasonDetail event,
    Emitter<SeasonDetailState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    try {
      final response = await remoteDataSource.getSeasonDetail(
        event.tvId,
        event.seasonNumber,
      );
      emit(
        state.copyWith(state: RequestState.Loaded, episodes: response.episodes),
      );
    } catch (e) {
      emit(state.copyWith(state: RequestState.Error, message: e.toString()));
    }
  }
}
