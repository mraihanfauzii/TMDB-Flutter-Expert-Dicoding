// import 'package:movie/domain/entities/movie.dart';
// import 'package:core/utils/state_enum.dart';
// import 'package:movie/domain/usecases/get_now_playing_movies.dart';
// import 'package:flutter/foundation.dart';
//
// class NowPlayingMoviesNotifier extends ChangeNotifier {
//   final GetNowPlayingMovies getNowPlayingMovies;
//
//   NowPlayingMoviesNotifier(this.getNowPlayingMovies);
//
//   RequestState _state = RequestState.Empty;
//   RequestState get state => _state;
//
//   List<Movie> _movies = [];
//   List<Movie> get movies => _movies;
//
//   String _message = '';
//   String get message => _message;
//
//   Future<void> fetchNowPlayingMovies() async {
//     _state = RequestState.Loading;
//     notifyListeners();
//
//     final result = await getNowPlayingMovies.execute();
//     result.fold(
//       (failure) {
//         _state = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (movieData) {
//         _state = RequestState.Loaded;
//         _movies = movieData;
//         notifyListeners();
//       },
//     );
//   }
// }
