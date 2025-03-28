// import 'package:tv/domain/entities/tv.dart';
// import 'package:flutter/foundation.dart';
// import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
// import 'package:core/utils/state_enum.dart';
//
// class TopRatedTvNotifier extends ChangeNotifier {
//   final GetTopRatedTvs getTopRatedTvs;
//
//   TopRatedTvNotifier({required this.getTopRatedTvs});
//
//   RequestState _state = RequestState.Empty;
//   RequestState get state => _state;
//
//   List<Tv> _tvs = [];
//   List<Tv> get tvs => _tvs;
//
//   String _message = '';
//   String get message => _message;
//
//   Future<void> fetchTopRatedTvs() async {
//     _state = RequestState.Loading;
//     notifyListeners();
//
//     final result = await getTopRatedTvs.execute();
//     result.fold(
//       (failure) {
//         _state = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (data) {
//         _tvs = data;
//         _state = RequestState.Loaded;
//         notifyListeners();
//       },
//     );
//   }
// }
