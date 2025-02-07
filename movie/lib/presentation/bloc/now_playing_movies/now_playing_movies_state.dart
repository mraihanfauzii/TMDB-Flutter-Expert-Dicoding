import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';

class NowPlayingMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const NowPlayingMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  NowPlayingMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return NowPlayingMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}
