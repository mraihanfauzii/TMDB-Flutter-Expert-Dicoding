import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  const TvTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TvTable.fromEntity(TvDetail tv) => TvTable(
    id: tv.id,
    name: tv.name,
    posterPath: tv.posterPath,
    overview: tv.overview,
  );

  factory TvTable.fromMap(Map<String, dynamic> map) => TvTable(
    id: map['id'],
    name: map['name'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'posterPath': posterPath,
    'overview': overview,
  };

  Tv toEntity() => Tv(
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
    voteAverage: null,
    firstAirDate: null,
  );

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
