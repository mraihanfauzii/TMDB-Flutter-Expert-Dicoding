import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/season_model.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2021-09-17',
    episodeCount: 9,
    id: 999,
    name: 'Season 1',
    overview: 'Season overview',
    posterPath: '/season.jpg',
    seasonNumber: 1,
    voteAverage: 8.0,
  );

  test('fromJson should parse correctly', () {
    final json = {
      "air_date": "2021-09-17",
      "episode_count": 9,
      "id": 999,
      "name": "Season 1",
      "overview": "Season overview",
      "poster_path": "/season.jpg",
      "season_number": 1,
      "vote_average": 8.0
    };
    final result = SeasonModel.fromJson(json);
    expect(result, tSeasonModel);
  });

  test('toJson should return valid map', () {
    final result = tSeasonModel.toJson();
    expect(result["id"], 999);
    expect(result["poster_path"], '/season.jpg');
  });

  test('toEntity should convert to Season entity', () {
    final entity = tSeasonModel.toEntity();
    expect(entity.id, 999);
    expect(entity.name, 'Season 1');
    expect(entity.voteAverage, 8.0);
  });

  test('hasPoster', () {
    const season = SeasonModel(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 123,
      name: 'Season 1',
      overview: 'Overview ...',
      posterPath: '/season.jpg',
      seasonNumber: 1,
      voteAverage: 7.5,
    );
    expect(season.posterPath != null, true);
  });
}
