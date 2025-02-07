import 'package:tv/data/models/episode_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    airDate: '2021-09-17',
    episodeNumber: 1,
    episodeType: 'standard',
    id: 999,
    name: 'Red Light',
    overview: 'Overview ep',
    runtime: 61,
    seasonNumber: 1,
    showId: 93405,
    stillPath: '/path.jpg',
    voteAverage: 8.2,
    voteCount: 100,
  );

  test('should parse from JSON', () {
    final json = {
      "air_date": "2021-09-17",
      "episode_number": 1,
      "episode_type": "standard",
      "id": 999,
      "name": "Red Light",
      "overview": "Overview ep",
      "runtime": 61,
      "season_number": 1,
      "show_id": 93405,
      "still_path": "/path.jpg",
      "vote_average": 8.2,
      "vote_count": 100
    };

    final result = EpisodeModel.fromJson(json);
    expect(result, tEpisodeModel);
  });

  test('should convert to JSON', () {
    final result = tEpisodeModel.toJson();
    expect(result["name"], "Red Light");
    expect(result["vote_count"], 100);
  });
}
