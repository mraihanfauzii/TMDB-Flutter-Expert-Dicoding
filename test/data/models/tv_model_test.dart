import 'package:ditonton/data/models/tv_model.dart';
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

  test('should be able to convert from JSON', () {
    final Map<String, dynamic> jsonMap = {
      "id": 1,
      "name": "Test TV",
      "overview": "Overview",
      "poster_path": "/path.jpg",
      "vote_average": 8.0,
      "first_air_date": "2023-01-01",
    };

    final result = TvModel.fromJson(jsonMap);
    expect(result, tTvModel);
  });

  test('should be able to convert to JSON', () {
    final result = tTvModel.toJson();
    final expectedJson = {
      "id": 1,
      "name": "Test TV",
      "overview": "Overview",
      "poster_path": "/path.jpg",
      "vote_average": 8.0,
      "first_air_date": "2023-01-01",
    };
    expect(result, expectedJson);
  });
}
