import 'package:tv/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_detail_model.dart';

void main() {
  const tTvDetailResponse = TvDetailResponse(
    id: 1,
    name: 'Sample TV',
    posterPath: '/poster.jpg',
    overview: 'overview',
    voteAverage: 7.8,
    genres: [
      {"id": 18, "name": "Drama"}
    ],
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
    seasons: [
      SeasonModel(
        airDate: '2020-01-01',
        episodeCount: 8,
        id: 100,
        name: 'Season 1',
        overview: 'Season overview',
        posterPath: '/posterS1.jpg',
        seasonNumber: 1,
        voteAverage: 7.5,
      )
    ],
  );

  test('fromJson should parse correctly', () {
    final json = {
      "id": 1,
      "name": "Sample TV",
      "poster_path": "/poster.jpg",
      "overview": "overview",
      "vote_average": 7.8,
      "genres": [
        {"id": 18, "name": "Drama"}
      ],
      "number_of_episodes": 10,
      "number_of_seasons": 2,
      "seasons": [
        {
          "air_date": "2020-01-01",
          "episode_count": 8,
          "id": 100,
          "name": "Season 1",
          "overview": "Season overview",
          "poster_path": "/posterS1.jpg",
          "season_number": 1,
          "vote_average": 7.5
        }
      ]
    };
    final result = TvDetailResponse.fromJson(json);
    expect(result, tTvDetailResponse);
  });

  test('toJson should return valid JSON map', () {
    final result = tTvDetailResponse.toJson();
    expect(result["id"], 1);
    expect(result["genres"], isA<List>());
  });

  test('toEntity should return TvDetail entity', () {
    final entity = tTvDetailResponse.toEntity();
    expect(entity.id, 1);
    expect(entity.genres.first, 'Drama');
  });
}
