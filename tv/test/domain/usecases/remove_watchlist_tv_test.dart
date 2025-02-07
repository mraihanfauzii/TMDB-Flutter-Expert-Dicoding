import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockRepository;

  setUp(() {
    mockRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockRepository);
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

  test('should remove tv from repository', () async {
    // arrange
    when(mockRepository.removeWatchlistTv(tTvDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(tTvDetail);
    // assert
    expect(result, const Right('Removed from Watchlist'));
  });

  test('should return DatabaseFailure when remove fails', () async {
    // arrange
    when(mockRepository.removeWatchlistTv(tTvDetail))
        .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
    // act
    final result = await usecase.execute(tTvDetail);
    // assert
    expect(result, const Left(DatabaseFailure('Failed')));
  });
}