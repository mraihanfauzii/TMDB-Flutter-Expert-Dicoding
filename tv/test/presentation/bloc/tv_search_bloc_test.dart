import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc bloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    bloc = TvSearchBloc(searchTvs: mockSearchTvs);
  });

  const tQuery = 'kraven';
  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: 'posterPath',
    voteAverage: 8.0,
    firstAirDate: '2023-01-01',
  );
  final tTvList = <Tv>[tTv];

  group('FetchTvSearch', () {
    blocTest<TvSearchBloc, TvSearchState>(
      'emits [Loading, Loaded] when search is successful',
      build: () {
        when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSearch(tQuery)),
      expect: () => [
        const TvSearchState(state: RequestState.Loading),
        TvSearchState(state: RequestState.Loaded, tvs: tTvList),
      ],
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvSearch(tQuery)),
      expect: () => [
        const TvSearchState(state: RequestState.Loading),
        const TvSearchState(state: RequestState.Error, message: 'Error'),
      ],
    );
  });
}
