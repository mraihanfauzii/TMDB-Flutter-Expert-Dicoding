import 'package:tv/data/models/season_model.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final List<dynamic> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<SeasonModel> seasons;

  const TvDetailResponse({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.genres,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.seasons,
  });

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) {
    final rawGenres = json["genres"];
    final rawSeasons = json["seasons"];

    return TvDetailResponse(
      id: json["id"],
      name: json["name"],
      posterPath: json["poster_path"],
      overview: json["overview"],
      voteAverage: (json["vote_average"] as num).toDouble(),
      genres:
          rawGenres == null ? [] : (rawGenres as List).map((g) => g).toList(),
      numberOfEpisodes: json["number_of_episodes"] ?? 0,
      numberOfSeasons: json["number_of_seasons"] ?? 0,
      seasons:
          rawSeasons == null
              ? []
              : (rawSeasons as List)
                  .map((s) => SeasonModel.fromJson(s))
                  .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "poster_path": posterPath,
    "overview": overview,
    "vote_average": voteAverage,
    "genres": genres,
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasons,
    "seasons": seasons.map((s) => s.toJson()).toList(),
  };

  TvDetail toEntity() {
    final genreNames = genres.map((g) => g['name'] as String).toList();
    return TvDetail(
      id: id,
      name: name,
      posterPath: posterPath,
      overview: overview,
      voteAverage: voteAverage,
      genres: List<String>.from(genreNames),
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      seasons: seasons.map((s) => s.toEntity()).toList(),
    );
  }

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
