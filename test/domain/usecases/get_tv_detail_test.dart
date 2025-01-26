import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  const tId = 1;
  const tTvDetail = TvDetail(
    id: 1,
    name: 'Test Tv',
    posterPath: '/path.jpg',
    overview: 'Overview',
    voteAverage: 7.5,
    genres: [],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
  );

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvDetail(tId))
        .thenAnswer((_) async => const Right(tTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, const Right(tTvDetail));
  });
}
