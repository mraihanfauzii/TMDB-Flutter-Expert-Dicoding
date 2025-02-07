import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';

class MovieListState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingState;
  final List<Movie> popularMovies;
  final RequestState popularState;
  final List<Movie> topRatedMovies;
  final RequestState topRatedState;
  final String message;

  const MovieListState({
    this.nowPlayingMovies = const [],
    this.nowPlayingState = RequestState.Empty,
    this.popularMovies = const [],
    this.popularState = RequestState.Empty,
    this.topRatedMovies = const [],
    this.topRatedState = RequestState.Empty,
    this.message = '',
  });

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    RequestState? nowPlayingState,
    List<Movie>? popularMovies,
    RequestState? popularState,
    List<Movie>? topRatedMovies,
    RequestState? topRatedState,
    String? message,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularMovies: popularMovies ?? this.popularMovies,
      popularState: popularState ?? this.popularState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedState: topRatedState ?? this.topRatedState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingMovies,
        nowPlayingState,
        popularMovies,
        popularState,
        topRatedMovies,
        topRatedState,
        message,
      ];
}
