import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnAirTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListNotifier notifier;
  late MockGetOnAirTvs mockGetOnAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetOnAirTvs = MockGetOnAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    notifier = TvListNotifier(
      getOnAirTvs: mockGetOnAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  final tTvList = <Tv>[
    const Tv(
      id: 1,
      name: 'Test Tv',
      overview: 'Overview test',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
      firstAirDate: '2023-01-01',
    )
  ];

  group('fetchOnAirTvs', () {
    test('should change state to loading then to loaded when success', () async {
      // arrange
      when(mockGetOnAirTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await notifier.fetchOnAirTvs();
      // assert
      expect(notifier.onAirState, RequestState.Loaded);
      expect(notifier.onAirTvs, tTvList);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnAirTvs.execute()).thenAnswer((_) async => const Left(ServerFailure('Error')));
      // act
      await notifier.fetchOnAirTvs();
      // assert
      expect(notifier.onAirState, RequestState.Error);
      expect(notifier.message, 'Error');
    });
  });

  group('fetchPopularTvs', () {
    test('should change state to loading then loaded when success', () async {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      await notifier.fetchPopularTvs();
      expect(notifier.popularState, RequestState.Loaded);
      expect(notifier.popularTvs, tTvList);
    });

    test('should return error when fail', () async {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => const Left(ServerFailure('Pop Error')));
      await notifier.fetchPopularTvs();
      expect(notifier.popularState, RequestState.Error);
      expect(notifier.message, 'Pop Error');
    });
  });

  group('fetchTopRatedTvs', () {
    test('should change state to loading then loaded when success', () async {
      when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
      await notifier.fetchTopRatedTvs();
      expect(notifier.topRatedState, RequestState.Loaded);
      expect(notifier.topRatedTvs, tTvList);
    });

    test('should return error when fail', () async {
      when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => const Left(ServerFailure('Top Error')));
      await notifier.fetchTopRatedTvs();
      expect(notifier.topRatedState, RequestState.Error);
      expect(notifier.message, 'Top Error');
    });
  });
}