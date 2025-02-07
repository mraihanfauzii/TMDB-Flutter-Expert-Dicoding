import 'package:equatable/equatable.dart';

abstract class OnAirTvEvent extends Equatable {
  const OnAirTvEvent();
  @override
  List<Object> get props => [];
}

class FetchOnAirTv extends OnAirTvEvent {}
