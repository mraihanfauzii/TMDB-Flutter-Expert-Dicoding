import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_event.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_state.dart';

import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvBloc bloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TopRatedTvBloc(getTopRatedTvs: mockGetTopRatedTvs);
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('TopRatedTvEvent', () {
    test('FetchTopRatedTv props', () {
      final event = FetchTopRatedTv();
      expect(event.props, []);
    });
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('TopRatedTvState', () {
    test('supports value equality', () {
      expect(const TopRatedTvState(), const TopRatedTvState());
    });

    test('props test', () {
      const state = TopRatedTvState(
        state: RequestState.Loading,
        tvs: [],
        message: 'error msg',
      );
      expect(state.props, [RequestState.Loading, [], 'error msg']);
    });

    test('copyWith test', () {
      const state = TopRatedTvState();
      final newState = state.copyWith(
        state: RequestState.Loaded,
        tvs: [Tv(id: 1, name: 'xx', overview: '', posterPath: '', voteAverage: 7, firstAirDate: '2022')],
        message: 'hello',
      );
      expect(newState.state, RequestState.Loaded);
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

  group('FetchTopRatedTv', () {
    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'emits [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        const TopRatedTvState(state: RequestState.Loading),
        TopRatedTvState(state: RequestState.Loaded, tvs: tTvList),
      ],
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'emits [Loading, Error] when data fetch fails',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        const TopRatedTvState(state: RequestState.Loading),
        const TopRatedTvState(state: RequestState.Error, message: 'Error'),
      ],
    );
  });
}
