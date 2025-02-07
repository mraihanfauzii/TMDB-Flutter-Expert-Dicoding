import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';

class MovieSearchState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const MovieSearchState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}
