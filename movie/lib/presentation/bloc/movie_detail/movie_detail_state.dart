import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';

class MovieDetailState extends Equatable {
  final RequestState movieState;
  final MovieDetail? movieDetail;
  final String message;
  final RequestState recommendationState;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.movieState = RequestState.Empty,
    this.movieDetail,
    this.message = '',
    this.recommendationState = RequestState.Empty,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    RequestState? movieState,
    MovieDetail? movieDetail,
    String? message,
    RequestState? recommendationState,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieState: movieState ?? this.movieState,
      movieDetail: movieDetail ?? this.movieDetail,
      message: message ?? this.message,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movieState,
    movieDetail,
    message,
    recommendationState,
    recommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
