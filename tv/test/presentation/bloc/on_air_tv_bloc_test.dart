import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_air_tvs.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_event.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_state.dart';

import 'on_air_tv_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvs])
void main() {
  late OnAirTvBloc bloc;
  late MockGetOnAirTvs mockGetOnAirTvs;

  setUp(() {
    mockGetOnAirTvs = MockGetOnAirTvs();
    bloc = OnAirTvBloc(getOnAirTvs: mockGetOnAirTvs);
  });

  // ---------------------
  // EVENT COVERAGE
  // ---------------------
  group('OnAirTvEvent', () {
    test('FetchOnAirTv props', () {
      final event = FetchOnAirTv();
      expect(event.props, []);
    });

    // Jika Anda punya event lain, tambahkan di sini
  });

  // ---------------------
  // STATE COVERAGE
  // ---------------------
  group('OnAirTvState', () {
    test('supports value equality', () {
      // pastikan Equatable bekerja
      expect(
        const OnAirTvState(),
        const OnAirTvState(),
      );
    });

    test('props test', () {
      const state = OnAirTvState(
        state: RequestState.Loaded,
        tvs: [],
        message: 'ok',
      );
      expect(state.props, [RequestState.Loaded, [], 'ok']);
    });

    test('copyWith test', () {
      const state = OnAirTvState();
      final newState = state.copyWith(
        state: RequestState.Loading,
        tvs: [Tv(id: 1, name: 'test', overview: 'x', posterPath: 'y', voteAverage: 5.0, firstAirDate: '2020')],
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

  group('OnAirTvBloc test', () {
    blocTest<OnAirTvBloc, OnAirTvState>(
      'emits [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetOnAirTvs.execute()).thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnAirTv()),
      expect: () => [
        const OnAirTvState(state: RequestState.Loading),
        OnAirTvState(state: RequestState.Loaded, tvs: tTvList),
      ],
    );

    blocTest<OnAirTvBloc, OnAirTvState>(
      'emits [Loading, Error] when data fetch fails',
      build: () {
        when(mockGetOnAirTvs.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnAirTv()),
      expect: () => [
        const OnAirTvState(state: RequestState.Loading),
        const OnAirTvState(state: RequestState.Error, message: 'Error'),
      ],
    );
  });
}
