import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockRepository;

  setUp(() {
    mockRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockRepository);
  });

  const tId = 1;
  final tTvs = <Tv>[];

  test('should get list of tv recommendations from repository', () async {
    // arrange
    when(mockRepository.getTvRecommendations(tId)).thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvs));
    verify(mockRepository.getTvRecommendations(tId));
  });
}
