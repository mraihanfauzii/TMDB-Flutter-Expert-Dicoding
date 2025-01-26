import 'package:ditonton/domain/entities/season.dart';
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
        seasons
      ];
}
