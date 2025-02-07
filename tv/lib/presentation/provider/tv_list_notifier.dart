// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/usecases/get_popular_tvs.dart';
// import 'package:flutter/foundation.dart';
// import 'package:core/utils/state_enum.dart';
// import 'package:tv/domain/usecases/get_on_air_tvs.dart';
// import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
//
// class TvListNotifier extends ChangeNotifier {
//   final GetOnAirTvs getOnAirTvs;
//   final GetPopularTvs getPopularTvs;
//   final GetTopRatedTvs getTopRatedTvs;
//
//   TvListNotifier({
//     required this.getOnAirTvs,
//     required this.getPopularTvs,
//     required this.getTopRatedTvs,
//   });
//
//   RequestState _onAirState = RequestState.Empty;
//   RequestState get onAirState => _onAirState;
//
//   List<Tv> _onAirTvs = [];
//   List<Tv> get onAirTvs => _onAirTvs;
//
//   RequestState _popularState = RequestState.Empty;
//   RequestState get popularState => _popularState;
//
//   List<Tv> _popularTvs = [];
//   List<Tv> get popularTvs => _popularTvs;
//
//   RequestState _topRatedState = RequestState.Empty;
//   RequestState get topRatedState => _topRatedState;
//
//   List<Tv> _topRatedTvs = [];
//   List<Tv> get topRatedTvs => _topRatedTvs;
//
//   String _message = '';
//   String get message => _message;
//
//   Future<void> fetchOnAirTvs() async {
//     _onAirState = RequestState.Loading;
//     notifyListeners();
//     final result = await getOnAirTvs.execute();
//     result.fold(
//       (failure) {
//         _onAirState = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (data) {
//         _onAirState = RequestState.Loaded;
//         _onAirTvs = data;
//         notifyListeners();
//       },
//     );
//   }
//
//   Future<void> fetchPopularTvs() async {
//     _popularState = RequestState.Loading;
//     notifyListeners();
//     final result = await getPopularTvs.execute();
//     result.fold(
//       (failure) {
//         _popularState = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (data) {
//         _popularState = RequestState.Loaded;
//         _popularTvs = data;
//         notifyListeners();
//       },
//     );
//   }
//
//   Future<void> fetchTopRatedTvs() async {
//     _topRatedState = RequestState.Loading;
//     notifyListeners();
//     final result = await getTopRatedTvs.execute();
//     result.fold(
//       (failure) {
//         _topRatedState = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (data) {
//         _topRatedState = RequestState.Loaded;
//         _topRatedTvs = data;
//         notifyListeners();
//       },
//     );
//   }
// }
