import 'package:equatable/equatable.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:core/utils/state_enum.dart';

class SeasonDetailState extends Equatable {
  final RequestState state;
  final List<EpisodeModel> episodes;
  final String message;

  const SeasonDetailState({
    this.state = RequestState.Empty,
    this.episodes = const [],
    this.message = '',
  });

  SeasonDetailState copyWith({
    RequestState? state,
    List<EpisodeModel>? episodes,
    String? message,
  }) {
    return SeasonDetailState(
      state: state ?? this.state,
      episodes: episodes ?? this.episodes,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, episodes, message];
}
