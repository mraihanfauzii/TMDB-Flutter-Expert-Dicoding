import 'package:equatable/equatable.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSearch extends TvSearchEvent {
  final String query;

  const FetchTvSearch(this.query);

  @override
  List<Object> get props => [query];
}
