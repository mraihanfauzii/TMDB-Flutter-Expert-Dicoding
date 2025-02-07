// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/usecases/get_popular_tvs.dart';
// import 'package:flutter/foundation.dart';
// import 'package:core/utils/state_enum.dart';
//
// class PopularTvNotifier extends ChangeNotifier {
//   final GetPopularTvs getPopularTvs;
//
//   PopularTvNotifier({required this.getPopularTvs});
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
//   Future<void> fetchPopularTvs() async {
//     _state = RequestState.Loading;
//     notifyListeners();
//
//     final result = await getPopularTvs.execute();
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
