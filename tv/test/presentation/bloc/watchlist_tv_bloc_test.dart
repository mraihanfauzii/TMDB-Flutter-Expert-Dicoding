import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    bloc = WatchlistTvBloc(getWatchlistTvs: mockGetWatchlistTvs);
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('WatchlistTvEvent', () {
    test('FetchWatchlistTv props', () {
      final event = FetchWatchlistTv();
      expect(event.props, []);
    });
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('WatchlistTvState', () {
    test('supports value equality', () {
      expect(const WatchlistTvState(), const WatchlistTvState());
    });

    test('props test', () {
      const state = WatchlistTvState(
        state: RequestState.Loaded,
        tvs: [],
        message: 'err',
      );
      expect(state.props, [RequestState.Loaded, [], 'err']);
    });

    test('copyWith test', () {
      const state = WatchlistTvState();
      final newState = state.copyWith(
        state: RequestState.Error,
        tvs: [Tv(id: 1, name: 'X', overview: 'Y', posterPath: 'Z', voteAverage: 7, firstAirDate: '2022')],
        message: 'hello',
      );
      expect(newState.state, RequestState.Error);
      expect(newState.tvs.length, 1);
      expect(newState.message, 'hello');
    });
  });

  // ---------------------
  // BLOC TEST
  // ---------------------
  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: 'posterPath',
    voteAverage: 8.0,
    firstAirDate: '2023-01-01',
  );
  final tTvList = <Tv>[tTv];

  group('FetchWatchlistTv', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'emits [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvs.execute()).thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        const WatchlistTvState(state: RequestState.Loading),
        WatchlistTvState(state: RequestState.Loaded, tvs: tTvList),
      ],
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'emits [Loading, Error] when data fetch fails',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        const WatchlistTvState(state: RequestState.Loading),
        const WatchlistTvState(state: RequestState.Error, message: 'Error'),
      ],
    );
  });
}
