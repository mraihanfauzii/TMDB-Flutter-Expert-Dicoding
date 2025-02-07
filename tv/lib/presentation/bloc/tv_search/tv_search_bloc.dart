import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs searchTvs;

  TvSearchBloc({required this.searchTvs}) : super(const TvSearchState()) {
    on<FetchTvSearch>(_onFetchTvSearch);
  }

  Future<void> _onFetchTvSearch(
      FetchTvSearch event, Emitter<TvSearchState> emit) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await searchTvs.execute(event.query);
    result.fold(
      (failure) {
        emit(state.copyWith(
            state: RequestState.Error, message: failure.message));
      },
      (tvs) {
        emit(state.copyWith(state: RequestState.Loaded, tvs: tvs));
      },
    );
  }
}
