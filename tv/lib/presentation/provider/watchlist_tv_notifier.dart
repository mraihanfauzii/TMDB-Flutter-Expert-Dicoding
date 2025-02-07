// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
// import 'package:flutter/foundation.dart';
// import 'package:core/utils/state_enum.dart';
//
// class WatchlistTvNotifier extends ChangeNotifier {
//   final GetWatchlistTvs getWatchlistTvs;
//
//   WatchlistTvNotifier({required this.getWatchlistTvs});
//
//   List<Tv> _watchlistTvs = [];
//   List<Tv> get watchlistTvs => _watchlistTvs;
//
//   RequestState _watchlistState = RequestState.Empty;
//   RequestState get watchlistState => _watchlistState;
//
//   String _message = '';
//   String get message => _message;
//
//   Future<void> fetchWatchlistTvs() async {
//     _watchlistState = RequestState.Loading;
//     notifyListeners();
//
//     final result = await getWatchlistTvs.execute();
//     result.fold(
//       (failure) {
//         _watchlistState = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (tvs) {
//         _watchlistState = RequestState.Loaded;
//         _watchlistTvs = tvs;
//         notifyListeners();
//       },
//     );
//   }
// }
