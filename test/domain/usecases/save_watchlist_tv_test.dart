import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockRepository;

  setUp(() {
    mockRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockRepository);
  });

  const tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    posterPath: '/path.jpg',
    overview: 'overview',
    voteAverage: 8.0,
    genres: ['Action'],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
  );

  test('should save tv to the repository', () async {
    // arrange
    when(mockRepository.saveWatchlistTv(tTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(tTvDetail);
    // assert
    expect(result, const Right('Added to Watchlist'));
  });

  test('should return DatabaseFailure when unsuccessful', () async {
    // arrange
    when(mockRepository.saveWatchlistTv(tTvDetail))
        .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
    // act
    final result = await usecase.execute(tTvDetail);
    // assert
    expect(result, const Left(DatabaseFailure('Failed')));
  });
}