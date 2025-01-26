import 'package:ditonton/data/models/episode_model.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  final int id;
  final String name;
  final List<EpisodeModel> episodes;

  const SeasonDetailResponse({
    required this.id,
    required this.name,
    required this.episodes,
  });

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json['id'],
        name: json['name'] ?? '',
        episodes: (json['episodes'] as List)
            .map((e) => EpisodeModel.fromJson(e))
            .toList(),
      );

  @override
  List<Object?> get props => [id, name, episodes];
}
