import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvBloc bloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    bloc = PopularTvBloc(getPopularTvs: mockGetPopularTvs);
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('PopularTvEvent', () {
    test('FetchPopularTv props', () {
      final event = FetchPopularTv();
      expect(event.props, []);
    });
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('PopularTvState', () {
    test('supports value equality', () {
      expect(const PopularTvState(), const PopularTvState());
    });

    test('props test', () {
      const state = PopularTvState(
        state: RequestState.Loaded,
        tvs: [],
        message: 'msg',
      );
      expect(state.props, [RequestState.Loaded, [], 'msg']);
    });

    test('copyWith test', () {
      const state = PopularTvState();
      final newState = state.copyWith(
        state: RequestState.Loading,
        tvs: [Tv(id: 1, name: 'xx', overview: 'yy', posterPath: 'z', voteAverage: 7.0, firstAirDate: '2020')],
        message: 'hello',
      );
      expect(newState.state, RequestState.Loading);
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

  group('PopularTvBloc test', () {
    blocTest<PopularTvBloc, PopularTvState>(
      'emits [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        const PopularTvState(state: RequestState.Loading),
        PopularTvState(state: RequestState.Loaded, tvs: tTvList),
      ],
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'emits [Loading, Error] when data fetch fails',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        const PopularTvState(state: RequestState.Loading),
        const PopularTvState(state: RequestState.Error, message: 'Error'),
      ],
    );
  });
}
