// import 'package:dartz/dartz.dart';
// import 'package:core/utils/failure.dart';
// import 'package:core/utils/state_enum.dart';
// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/usecases/search_tvs.dart';
// import 'package:tv/presentation/provider/tv_search_notifier.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// import 'tv_search_notifier_test.mocks.dart';
//
// @GenerateMocks([SearchTvs])
// void main() {
//   late TvSearchNotifier provider;
//   late MockSearchTvs mockSearchTvs;
//
//   setUp(() {
//     mockSearchTvs = MockSearchTvs();
//     provider = TvSearchNotifier(searchTvs: mockSearchTvs);
//   });
//
//   final tTvs = <Tv>[];
//   const tQuery = 'kraven';
//
//   test('should change state to loading then loaded when search success', () async {
//     // arrange
//     when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvs));
//     // act
//     provider.fetchTvSearch(tQuery);
//     // assert
//     expect(provider.state, RequestState.Loading);
//     await Future.delayed(Duration.zero);
//     expect(provider.state, RequestState.Loaded);
//     expect(provider.searchResult, tTvs);
//   });
//
//   test('should return error when search fails', () async {
//     // arrange
//     when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => const Left(ServerFailure('Error')));
//     // act
//     provider.fetchTvSearch(tQuery);
//     // assert
//     expect(provider.state, RequestState.Loading);
//     await Future.delayed(Duration.zero);
//     expect(provider.state, RequestState.Error);
//     expect(provider.message, 'Error');
//   });
// }
