import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/tv.dart';

class TvModel extends Equatable {
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final double? voteAverage;
  final String? firstAirDate;

  const TvModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.firstAirDate,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      id: json["id"],
      name: json["name"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      voteAverage: (json["vote_average"] as num?)?.toDouble(),
      firstAirDate: json["first_air_date"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "first_air_date": firstAirDate,
      };

  Tv toEntity() {
    return Tv(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      firstAirDate: firstAirDate,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, overview, posterPath, voteAverage, firstAirDate];
}
