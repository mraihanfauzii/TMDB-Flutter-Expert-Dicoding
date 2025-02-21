import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_state.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListBloc bloc;
  late MockGetOnAirTvs mockGetOnAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetOnAirTvs = MockGetOnAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TvListBloc(
      getOnAirTvs: mockGetOnAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('TvListEvent', () {
    test('FetchTvList props', () {
      final event = FetchTvList();
      expect(event.props, []);
    });
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('TvListState', () {
    test('supports value equality', () {
      expect(const TvListState(), const TvListState());
    });

    test('props test', () {
      const state = TvListState(
        onAirTvs: [],
        onAirState: RequestState.Loading,
        popularTvs: [],
        popularState: RequestState.Error,
        topRatedTvs: [],
        topRatedState: RequestState.Empty,
        message: 'msg',
      );
      expect(state.props, [
        [],
        RequestState.Loading,
        [],
        RequestState.Error,
        [],
        RequestState.Empty,
        'msg',
      ]);
    });

    test('copyWith test', () {
      const state = TvListState();
      final newState = state.copyWith(
        onAirState: RequestState.Loaded,
        onAirTvs: [Tv(id: 1, name: 'xx', overview: 'yy', posterPath: 'zz', voteAverage: 6.0, firstAirDate: '2022')],
        popularState: RequestState.Loading,
        topRatedState: RequestState.Error,
        message: 'hi',
      );
      expect(newState.onAirState, RequestState.Loaded);
      expect(newState.onAirTvs.length, 1);
      expect(newState.popularState, RequestState.Loading);
      expect(newState.topRatedState, RequestState.Error);
      expect(newState.message, 'hi');
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

  group('FetchTvList', () {
    blocTest<TvListBloc, TvListState>(
      'emits [Loading -> (On Air Loaded) -> (Popular Loaded) -> (TopRated Loaded)] bila semua sukses',
      build: () {
        when(mockGetOnAirTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvList()),
      expect: () => [
        // Awal: semua Loading
        const TvListState(
          onAirState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        // On Air sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ).copyWith(onAirTvs: tTvList),

        // Popular sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularTvs: [],
          popularState: RequestState.Loaded,
          topRatedState: RequestState.Loading,
        ).copyWith(onAirTvs: tTvList, popularTvs: tTvList),

        // Top Rated sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularTvs: [],
          popularState: RequestState.Loaded,
          topRatedTvs: [],
          topRatedState: RequestState.Loaded,
        ).copyWith(
          onAirTvs: tTvList,
          popularTvs: tTvList,
          topRatedTvs: tTvList,
        ),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'onAir error, tapi popular & topRated sukses',
      build: () {
        when(mockGetOnAirTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('onAir error')));
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvList()),
      expect: () => [
        // 1) All Loading
        const TvListState(
          onAirState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        // 2) onAir error
        const TvListState(
          onAirState: RequestState.Error,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
          message: 'onAir error',
        ),
        // 3) popular sukses
        const TvListState(
          onAirState: RequestState.Error,
          popularState: RequestState.Loaded,
          topRatedState: RequestState.Loading,
          message: 'onAir error',
        ).copyWith(popularTvs: tTvList),
        // 4) topRated sukses
        const TvListState(
          onAirState: RequestState.Error,
          popularState: RequestState.Loaded,
          topRatedState: RequestState.Loaded,
          message: 'onAir error',
        ).copyWith(popularTvs: tTvList, topRatedTvs: tTvList),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'popular error, onAir sukses, topRated sukses',
      build: () {
        when(mockGetOnAirTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('popular error')));
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvList()),
      expect: () => [
        // 1) Loading
        const TvListState(
          onAirState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        // 2) onAir sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ).copyWith(onAirTvs: tTvList),
        // 3) popular error
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularState: RequestState.Error,
          topRatedState: RequestState.Loading,
          message: 'popular error',
        ).copyWith(onAirTvs: tTvList),
        // 4) topRated sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularTvs: [],
          popularState: RequestState.Error,
          topRatedState: RequestState.Loaded,
          message: 'popular error',
        ).copyWith(onAirTvs: tTvList, topRatedTvs: tTvList),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'topRated error, sementara onAir & popular sukses',
      build: () {
        when(mockGetOnAirTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('topRated error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvList()),
      expect: () => [
        // 1) Loading
        const TvListState(
          onAirState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
        // 2) onAir sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ).copyWith(onAirTvs: tTvList),
        // 3) popular sukses
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularTvs: [],
          popularState: RequestState.Loaded,
          topRatedState: RequestState.Loading,
        ).copyWith(onAirTvs: tTvList, popularTvs: tTvList),
        // 4) topRated error
        const TvListState(
          onAirTvs: [],
          onAirState: RequestState.Loaded,
          popularTvs: [],
          popularState: RequestState.Loaded,
          topRatedState: RequestState.Error,
          message: 'topRated error',
        ).copyWith(onAirTvs: tTvList, popularTvs: tTvList),
      ],
    );
  });
}
