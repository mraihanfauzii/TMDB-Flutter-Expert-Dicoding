import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvs usecase;
  late MockTvRepository mockRepository;

  setUp(() {
    mockRepository = MockTvRepository();
    usecase = GetPopularTvs(mockRepository);
  });

  final tTvs = <Tv>[];

  test('should get list of popular tv from repository', () async {
    // arrange
    when(mockRepository.getPopularTvs()).thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvs));
    verify(mockRepository.getPopularTvs());
    verifyNoMoreInteractions(mockRepository);
  });
}