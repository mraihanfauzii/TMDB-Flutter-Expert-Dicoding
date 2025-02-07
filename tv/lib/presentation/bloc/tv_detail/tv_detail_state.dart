import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';

class TvDetailState extends Equatable {
  final RequestState tvState;
  final TvDetail? tvDetail;
  final String message;
  final RequestState recommendationState;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailState({
    this.tvState = RequestState.Empty,
    this.tvDetail,
    this.message = '',
    this.recommendationState = RequestState.Empty,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    RequestState? tvState,
    TvDetail? tvDetail,
    String? message,
    RequestState? recommendationState,
    List<Tv>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tvState: tvState ?? this.tvState,
      tvDetail: tvDetail ?? this.tvDetail,
      message: message ?? this.message,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvState,
        tvDetail,
        message,
        recommendationState,
        recommendations,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}
