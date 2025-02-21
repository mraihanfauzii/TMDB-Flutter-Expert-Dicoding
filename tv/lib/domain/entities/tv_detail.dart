import 'package:tv/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final List<String> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<Season> seasons;

  const TvDetail({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.genres,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    this.seasons = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    posterPath,
    overview,
    voteAverage,
    genres,
    numberOfEpisodes,
    numberOfSeasons,
    seasons,
  ];
}

extension on TvDetail {
  TvDetail copyWith({
    int? id,
    String? name,
    String? posterPath,
    String? overview,
    double? voteAverage,
    List<String>? genres,
    int? numberOfEpisodes,
    int? numberOfSeasons,
    List<Season>? seasons,
  }) {
    return TvDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      genres: genres ?? this.genres,
      numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      seasons: seasons ?? this.seasons,
    );
  }
}
