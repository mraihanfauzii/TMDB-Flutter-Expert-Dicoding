import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvModel = TvModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 8.0,
    firstAirDate: '2023-01-01',
  );

  const tTvResponse = TvResponse(tvList: [tTvModel]);

  test('should parse from JSON', () {
    final json = {
      "results": [
        {
          "id": 1,
          "name": "Test TV",
          "overview": "Overview",
          "poster_path": "/path.jpg",
          "vote_average": 8.0,
          "first_air_date": "2023-01-01"
        }
      ]
    };
    final result = TvResponse.fromJson(json);
    expect(result, tTvResponse);
  });

  test('should convert to JSON', () {
    final result = tTvResponse.toJson();
    expect((result['results'] as List).length, 1);
  });
}