import 'package:tv/data/models/season_detail_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should parse fromJson correctly', () {
    final json = {
      "id": 123,
      "name": "Season Name",
      "episodes": [
        {
          "id": 999,
          "name": "Episode 1",
          "episode_number": 1,
          "vote_average": 8.3,
        }
      ],
    };
    final result = SeasonDetailResponse.fromJson(json);
    expect(result.id, 123);
    expect(result.name, "Season Name");
    expect(result.episodes.length, 1);
    expect(result.episodes.first.name, "Episode 1");
  });

  test('should handle empty episodes', () {
    final json = {
      "id": 888,
      "name": "Season With No Episodes",
      "episodes": []
    };
    final result = SeasonDetailResponse.fromJson(json);
    expect(result.id, 888);
    expect(result.episodes.isEmpty, true);
  });
}