import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  final String? airDate;
  final int episodeNumber;
  final String episodeType;
  final int id;
  final String name;
  final String overview;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  const EpisodeModel({
    this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.id,
    required this.name,
    required this.overview,
    this.runtime,
    required this.seasonNumber,
    required this.showId,
    this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
    airDate: json["air_date"] as String?,
    episodeNumber: json["episode_number"] ?? 0,
    episodeType: json["episode_type"] ?? 'standard',
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    overview: json["overview"] ?? '',
    runtime: json["runtime"] as int?,
    seasonNumber: json["season_number"] ?? 0,
    showId: json["show_id"] ?? 0,
    stillPath: json["still_path"] as String?,
    voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
    voteCount: json["vote_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "air_date": airDate,
    "episode_number": episodeNumber,
    "episode_type": episodeType,
    "id": id,
    "name": name,
    "overview": overview,
    "runtime": runtime,
    "season_number": seasonNumber,
    "show_id": showId,
    "still_path": stillPath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  @override
  List<Object?> get props => [
    airDate,
    episodeNumber,
    episodeType,
    id,
    name,
    overview,
    runtime,
    seasonNumber,
    showId,
    stillPath,
    voteAverage,
    voteCount,
  ];
}
