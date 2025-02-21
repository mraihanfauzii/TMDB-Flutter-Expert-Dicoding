import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc bloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    bloc = TvSearchBloc(searchTvs: mockSearchTvs);
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('TvSearchEvent', () {
    test('FetchTvSearch props', () {
      const event = FetchTvSearch('query');
      expect(event.props, ['query']);
    });
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('TvSearchState', () {
    test('supports value equality', () {
      expect(const TvSearchState(), const TvSearchState());
    });

    test('props test', () {
      const state = TvSearchState(
        state: RequestState.Loaded,
        tvs: [],
        message: 'msg',
      );
      expect(state.props, [RequestState.Loaded, [], 'msg']);
    });

    test('copyWith test', () {
      const state = TvSearchState();
      final newState = state.copyWith(
        state: RequestState.Error,
        tvs: [Tv(id: 11, name: 'S', overview: 'O', posterPath: 'P', voteAverage: 7, firstAirDate: '2020')],
        message: 'err',
      );
      expect(newState.state, RequestState.Error);
      expect(newState.tvs.length, 1);
      expect(newState.message, 'err');
    });
  });

  // ---------------------
  // BLOC TEST
  // ---------------------
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
