import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';

class TvListState extends Equatable {
  final List<Tv> onAirTvs;
  final RequestState onAirState;
  final List<Tv> popularTvs;
  final RequestState popularState;
  final List<Tv> topRatedTvs;
  final RequestState topRatedState;
  final String message;

  const TvListState({
    this.onAirTvs = const [],
    this.onAirState = RequestState.Empty,
    this.popularTvs = const [],
    this.popularState = RequestState.Empty,
    this.topRatedTvs = const [],
    this.topRatedState = RequestState.Empty,
    this.message = '',
  });

  TvListState copyWith({
    List<Tv>? onAirTvs,
    RequestState? onAirState,
    List<Tv>? popularTvs,
    RequestState? popularState,
    List<Tv>? topRatedTvs,
    RequestState? topRatedState,
    String? message,
  }) {
    return TvListState(
      onAirTvs: onAirTvs ?? this.onAirTvs,
      onAirState: onAirState ?? this.onAirState,
      popularTvs: popularTvs ?? this.popularTvs,
      popularState: popularState ?? this.popularState,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      topRatedState: topRatedState ?? this.topRatedState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    onAirTvs,
    onAirState,
    popularTvs,
    popularState,
    topRatedTvs,
    topRatedState,
    message,
  ];
}
