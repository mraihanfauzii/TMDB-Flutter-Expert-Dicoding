import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';

class TopRatedTvState extends Equatable {
  final RequestState state;
  final List<Tv> tvs;
  final String message;

  const TopRatedTvState({
    this.state = RequestState.Empty,
    this.tvs = const [],
    this.message = '',
  });

  TopRatedTvState copyWith({
    RequestState? state,
    List<Tv>? tvs,
    String? message,
  }) {
    return TopRatedTvState(
      state: state ?? this.state,
      tvs: tvs ?? this.tvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, tvs, message];
}
