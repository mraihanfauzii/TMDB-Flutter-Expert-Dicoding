import 'package:equatable/equatable.dart';

abstract class PopularTvEvent extends Equatable {
  const PopularTvEvent();
  @override
  List<Object> get props => [];
}

class FetchPopularTv extends PopularTvEvent {}
