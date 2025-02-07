import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;
  const FetchTvDetail(this.id);
  @override
  List<Object> get props => [id];
}

class AddWatchlistTv extends TvDetailEvent {
  final TvDetail tv;
  const AddWatchlistTv(this.tv);
  @override
  List<Object> get props => [tv];
}

class RemoveWatchlistTvEvent extends TvDetailEvent {
  final TvDetail tv;
  const RemoveWatchlistTvEvent(this.tv);
  @override
  List<Object> get props => [tv];
}

class LoadWatchlistTvStatus extends TvDetailEvent {
  final int id;
  const LoadWatchlistTvStatus(this.id);
  @override
  List<Object> get props => [id];
}
