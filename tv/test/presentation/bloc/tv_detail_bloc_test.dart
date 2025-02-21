import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();

    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListTvStatus: mockGetWatchListTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('TvDetailEvent', () {
    test('FetchTvDetail props', () {
      const event = FetchTvDetail(1);
      expect(event.props, [1]);
    });

    test('AddWatchlistTv props', () {
      final tv = TvDetail(
        id: 999,
        name: 'Test tv',
        posterPath: '',
        overview: '',
        voteAverage: 0,
        genres: [],
        numberOfEpisodes: 0,
        numberOfSeasons: 0,
      );
      final event = AddWatchlistTv(tv);
      expect(event.props, [tv]);
    });

    test('RemoveWatchlistTvEvent props', () {
      final tv = TvDetail(
        id: 111,
        name: 'Test remove',
        posterPath: '',
        overview: '',
        voteAverage: 0,
        genres: [],
        numberOfEpisodes: 0,
        numberOfSeasons: 0,
      );
      final event = RemoveWatchlistTvEvent(tv);
      expect(event.props, [tv]);
    });

    test('LoadWatchlistTvStatus props', () {
      const event = LoadWatchlistTvStatus(321);
      expect(event.props, [321]);
    });
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('TvDetailState', () {
    test('supports value equality', () {
      expect(const TvDetailState(), const TvDetailState());
    });

    test('props test', () {
      const state = TvDetailState(
        tvState: RequestState.Loaded,
        message: 'message',
        recommendationState: RequestState.Error,
        recommendations: [],
        isAddedToWatchlist: true,
        watchlistMessage: 'msg',
      );
      expect(state.props, [
        RequestState.Loaded,
        null, // tvDetail
        'message',
        RequestState.Error,
        [],
        true,
        'msg',
      ]);
    });

    test('copyWith test', () {
      const state = TvDetailState();
      final newState = state.copyWith(
        tvState: RequestState.Loading,
        tvDetail: TvDetail(
          id: 99,
          name: 'Test name',
          posterPath: 'poster',
          overview: 'overview',
          voteAverage: 5.0,
          genres: [],
          numberOfEpisodes: 10,
          numberOfSeasons: 1,
        ),
        message: 'error',
        recommendationState: RequestState.Loaded,
        recommendations: [Tv(id: 7, name: 'X', overview: '', posterPath: '', voteAverage: 5.0, firstAirDate: '')],
        isAddedToWatchlist: true,
        watchlistMessage: 'watch msg',
      );
      expect(newState.tvState, RequestState.Loading);
      expect(newState.tvDetail!.id, 99);
      expect(newState.message, 'error');
      expect(newState.recommendationState, RequestState.Loaded);
      expect(newState.recommendations.length, 1);
      expect(newState.isAddedToWatchlist, true);
      expect(newState.watchlistMessage, 'watch msg');
    });
  });

  // ---------------------
  // BLOC TEST
  // ---------------------
  const tId = 1;
  final tTvDetail = TvDetail(
    id: tId,
    name: 'Test TV Detail',
    overview: 'Overview',
    posterPath: 'posterPath',
    voteAverage: 8.0,
    genres: [],
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
  );
  final tRecomendedTv = Tv(
    id: 999,
    name: 'Recommendation TV',
    overview: 'Overview',
    posterPath: 'posterPath',
    voteAverage: 7.5,
    firstAirDate: '2023-01-02',
  );
  final tTvList = <Tv>[tRecomendedTv];

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits [Loading -> Loaded -> recommendation Loaded] on success detail+recs',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.Loading),
        TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
        ),
        TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
          recommendationState: RequestState.Loaded,
          recommendations: tTvList,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'emits [Loading -> Loaded -> rec Error] when rec fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Error Recs')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.Loading),
        TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
        ),
        TvDetailState(
          tvState: RequestState.Loaded,
          tvDetail: tTvDetail,
          recommendationState: RequestState.Error,
          message: 'Error Recs',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'emits [Loading -> Error] when detail fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Error Detail')));
        // stub rec
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(<Tv>[]));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.Loading),
        const TvDetailState(tvState: RequestState.Error, message: 'Error Detail'),
      ],
    );
  });

  group('AddWatchlistTv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'add watchlist fail => emits 1 state if isAddedToWatchlist stays false',
      build: () {
        when(mockSaveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('DB Error')));
        // result => false
        when(mockGetWatchListTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const TvDetailState(isAddedToWatchlist: false),
      act: (bloc) => bloc.add(AddWatchlistTv(tTvDetail)),
      expect: () => [
        const TvDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'DB Error',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'add watchlist success => emits 2 states if isAddedToWatchlist changes false->true',
      build: () {
        when(mockSaveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => const TvDetailState(isAddedToWatchlist: false),
      act: (bloc) => bloc.add(AddWatchlistTv(tTvDetail)),
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const TvDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
        const TvDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
    );
  });

  group('RemoveWatchlistTvEvent', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'remove watchlist success => 2 states if from true -> false',
      build: () {
        when(mockRemoveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const TvDetailState(isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveWatchlistTvEvent(tTvDetail)),
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const TvDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Removed from Watchlist',
        ),
        const TvDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      "remove watchlist fails => 'Remove Error', stays true => only 1 state",
      build: () {
        when(mockRemoveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Remove Error')));
        // Tetap true
        when(mockGetWatchListTvStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => const TvDetailState(isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveWatchlistTvEvent(tTvDetail)),
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const TvDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Remove Error',
        ),
      ],
    );
  });

  group('LoadWatchlistTvStatus', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits isAddedToWatchlist = true',
      build: () {
        when(mockGetWatchListTvStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistTvStatus(tId)),
      expect: () => [
        const TvDetailState(isAddedToWatchlist: true),
      ],
    );
  });
}
