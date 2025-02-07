import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvBloc bloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    bloc = PopularTvBloc(getPopularTvs: mockGetPopularTvs);
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

  group('FetchPopularTv', () {
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
