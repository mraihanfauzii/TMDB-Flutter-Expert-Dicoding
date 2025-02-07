// import 'package:dartz/dartz.dart';
// import 'package:core/utils/failure.dart';
// import 'package:core/utils/state_enum.dart';
// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/entities/tv_detail.dart';
// import 'package:tv/domain/usecases/get_tv_detail.dart';
// import 'package:tv/domain/usecases/get_tv_recommendations.dart';
// import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
// import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
// import 'package:tv/domain/usecases/save_watchlist_tv.dart';
// import 'package:tv/presentation/provider/tv_detail_notifier.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// import 'tv_detail_notifier_test.mocks.dart';
//
// @GenerateMocks([
//   GetTvDetail,
//   GetTvRecommendations,
//   GetWatchListTvStatus,
//   SaveWatchlistTv,
//   RemoveWatchlistTv,
// ])
// void main() {
//   late TvDetailNotifier provider;
//   late MockGetTvDetail mockGetTvDetail;
//   late MockGetTvRecommendations mockGetTvRecommendations;
//   late MockGetWatchListTvStatus mockGetWatchListTvStatus;
//   late MockSaveWatchlistTv mockSaveWatchlistTv;
//   late MockRemoveWatchlistTv mockRemoveWatchlistTv;
//
//   setUp(() {
//     mockGetTvDetail = MockGetTvDetail();
//     mockGetTvRecommendations = MockGetTvRecommendations();
//     mockGetWatchListTvStatus = MockGetWatchListTvStatus();
//     mockSaveWatchlistTv = MockSaveWatchlistTv();
//     mockRemoveWatchlistTv = MockRemoveWatchlistTv();
//
//     provider = TvDetailNotifier(
//       getTvDetail: mockGetTvDetail,
//       getTvRecommendations: mockGetTvRecommendations,
//       getWatchListTvStatus: mockGetWatchListTvStatus,
//       saveWatchlistTv: mockSaveWatchlistTv,
//       removeWatchlistTv: mockRemoveWatchlistTv,
//     );
//   });
//
//   const tId = 1;
//   const tTvDetail = TvDetail(
//     id: tId,
//     name: 'Test Tv',
//     posterPath: '/path.jpg',
//     overview: 'Overview test',
//     voteAverage: 8.0,
//     genres: ['Drama'],
//     numberOfEpisodes: 10,
//     numberOfSeasons: 1,
//   );
//   final tTvList = <Tv>[
//     const Tv(
//       id: 101,
//       name: 'Rec Tv',
//       overview: 'Recommend overview',
//       posterPath: '/rec.jpg',
//       voteAverage: 6.6,
//       firstAirDate: '2023-05-05',
//     )
//   ];
//
//   group('fetchTvDetail', () {
//     test('should change state to loading then loaded when success', () async {
//       // arrange
//       when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => const Right(tTvDetail));
//       when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvList));
//       when(mockGetWatchListTvStatus.execute(tId)).thenAnswer((_) async => false);
//
//       // act
//       await provider.fetchTvDetail(tId);
//       // assert
//       expect(provider.tvState, RequestState.Loaded);
//       expect(provider.tv, tTvDetail);
//       expect(provider.tvRecommendations, tTvList);
//     });
//
//     test('should return error when detail fail', () async {
//       when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => const Left(ServerFailure('Error')));
//       // meski detail fail, recommendation dipanggil
//       when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => const Right([]));
//       when(mockGetWatchListTvStatus.execute(tId)).thenAnswer((_) async => false);
//
//       await provider.fetchTvDetail(tId);
//
//       expect(provider.tvState, RequestState.Error);
//       expect(provider.message, 'Error');
//     });
//
//     test('should return error when recommendation fail', () async {
//       when(mockGetTvDetail.execute(tId)).thenAnswer((_) async => const Right(tTvDetail));
//       when(mockGetTvRecommendations.execute(tId))
//           .thenAnswer((_) async => const Left(ServerFailure('Rec Error')));
//       when(mockGetWatchListTvStatus.execute(tId)).thenAnswer((_) async => false);
//
//       await provider.fetchTvDetail(tId);
//
//       expect(provider.recommendationState, RequestState.Error);
//       expect(provider.message, 'Rec Error');
//     });
//   });
//
//   group('addWatchlist', () {
//     test('should update watchlist message when success', () async {
//       // arrange
//       when(mockSaveWatchlistTv.execute(tTvDetail)).thenAnswer((_) async => const Right('Added to Watchlist'));
//       when(mockGetWatchListTvStatus.execute(tTvDetail.id)).thenAnswer((_) async => true);
//
//       // act
//       await provider.addWatchlist(tTvDetail);
//
//       // assert
//       expect(provider.watchlistMessage, 'Added to Watchlist');
//       expect(provider.isAddedToWatchlist, true);
//     });
//
//     test('should update error message when fail', () async {
//       when(mockSaveWatchlistTv.execute(tTvDetail)).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
//       when(mockGetWatchListTvStatus.execute(tTvDetail.id)).thenAnswer((_) async => false);
//
//       await provider.addWatchlist(tTvDetail);
//
//       expect(provider.watchlistMessage, 'Failed');
//       expect(provider.isAddedToWatchlist, false);
//     });
//   });
//
//   group('removeWatchlist', () {
//     test('should update message when remove success', () async {
//       when(mockRemoveWatchlistTv.execute(tTvDetail)).thenAnswer((_) async => const Right('Removed'));
//       when(mockGetWatchListTvStatus.execute(tTvDetail.id)).thenAnswer((_) async => false);
//
//       await provider.removeFromWatchlist(tTvDetail);
//
//       expect(provider.watchlistMessage, 'Removed');
//       expect(provider.isAddedToWatchlist, false);
//     });
//
//     test('should return error message when remove fail', () async {
//       when(mockRemoveWatchlistTv.execute(tTvDetail)).thenAnswer((_) async => const Left(DatabaseFailure('Remove Fail')));
//       when(mockGetWatchListTvStatus.execute(tTvDetail.id)).thenAnswer((_) async => true);
//
//       await provider.removeFromWatchlist(tTvDetail);
//
//       expect(provider.watchlistMessage, 'Remove Fail');
//       expect(provider.isAddedToWatchlist, true);
//     });
//   });
//
//   group('loadWatchlistStatus', () {
//     test('should load watchlist status true', () async {
//       when(mockGetWatchListTvStatus.execute(tId)).thenAnswer((_) async => true);
//       await provider.loadWatchlistStatus(tId);
//       expect(provider.isAddedToWatchlist, true);
//     });
//
//     test('should load watchlist status false', () async {
//       when(mockGetWatchListTvStatus.execute(tId)).thenAnswer((_) async => false);
//       await provider.loadWatchlistStatus(tId);
//       expect(provider.isAddedToWatchlist, false);
//     });
//   });
// }
