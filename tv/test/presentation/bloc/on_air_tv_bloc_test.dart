import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_air_tvs.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_event.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_state.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_air_tv_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvs])
void main() {
  late OnAirTvBloc bloc;
  late MockGetOnAirTvs mockGetOnAirTvs;

  setUp(() {
    mockGetOnAirTvs = MockGetOnAirTvs();
    bloc = OnAirTvBloc(getOnAirTvs: mockGetOnAirTvs);
  });

  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: 'posterPath',
    voteAverage: 8.0,
    firstAirDate: '2023-01-01',
  );
  final tTvList = <Tv>[tTv];

  group('FetchOnAirTv', () {
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
