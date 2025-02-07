// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/entities/tv_detail.dart';
// import 'package:tv/domain/usecases/get_tv_detail.dart';
// import 'package:tv/domain/usecases/get_tv_recommendations.dart';
// import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
// import 'package:tv/domain/usecases/save_watchlist_tv.dart';
// import 'package:flutter/foundation.dart';
// import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
// import 'package:core/utils/state_enum.dart';
//
// class TvDetailNotifier extends ChangeNotifier {
//   static const watchlistAddSuccessMessage = 'Added TV to Watchlist';
//   static const watchlistRemoveSuccessMessage = 'Removed TV from Watchlist';
//
//   final GetTvDetail getTvDetail;
//   final GetTvRecommendations getTvRecommendations;
//   final GetWatchListTvStatus getWatchListTvStatus;
//   final SaveWatchlistTv saveWatchlistTv;
//   final RemoveWatchlistTv removeWatchlistTv;
//
//   TvDetailNotifier({
//     required this.getTvDetail,
//     required this.getTvRecommendations,
//     required this.getWatchListTvStatus,
//     required this.saveWatchlistTv,
//     required this.removeWatchlistTv,
//   });
//
//   late TvDetail _tv;
//   TvDetail get tv => _tv;
//
//   RequestState _tvState = RequestState.Empty;
//   RequestState get tvState => _tvState;
//
//   List<Tv> _tvRecommendations = [];
//   List<Tv> get tvRecommendations => _tvRecommendations;
//
//   RequestState _recommendationState = RequestState.Empty;
//   RequestState get recommendationState => _recommendationState;
//
//   String _message = '';
//   String get message => _message;
//
//   bool _isAddedToWatchlist = false;
//   bool get isAddedToWatchlist => _isAddedToWatchlist;
//
//   Future<void> fetchTvDetail(int id) async {
//     _tvState = RequestState.Loading;
//     notifyListeners();
//     final detailResult = await getTvDetail.execute(id);
//     final recommendationResult = await getTvRecommendations.execute(id);
//
//     detailResult.fold((failure) {
//       _tvState = RequestState.Error;
//       _message = failure.message;
//       notifyListeners();
//     }, (tv) {
//       _tv = tv;
//       _tvState = RequestState.Loaded;
//       notifyListeners();
//
//       _recommendationState = RequestState.Loading;
//       recommendationResult.fold(
//         (failure) {
//           _recommendationState = RequestState.Error;
//           _message = failure.message;
//           notifyListeners();
//         },
//         (tvs) {
//           _recommendationState = RequestState.Loaded;
//           _tvRecommendations = tvs;
//           notifyListeners();
//         },
//       );
//     });
//   }
//
//   String _watchlistMessage = '';
//   String get watchlistMessage => _watchlistMessage;
//
//   Future<void> addWatchlist(TvDetail tv) async {
//     final result = await saveWatchlistTv.execute(tv);
//     await result.fold(
//       (failure) async {
//         _watchlistMessage = failure.message;
//       },
//       (successMessage) async {
//         _watchlistMessage = successMessage;
//       },
//     );
//     await loadWatchlistStatus(tv.id);
//   }
//
//   Future<void> removeFromWatchlist(TvDetail tv) async {
//     final result = await removeWatchlistTv.execute(tv);
//     await result.fold(
//       (failure) async {
//         _watchlistMessage = failure.message;
//       },
//       (successMessage) async {
//         _watchlistMessage = successMessage;
//       },
//     );
//     await loadWatchlistStatus(tv.id);
//   }
//
//   Future<void> loadWatchlistStatus(int id) async {
//     final result = await getWatchListTvStatus.execute(id);
//     _isAddedToWatchlist = result;
//     notifyListeners();
//   }
// }
