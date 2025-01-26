import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/genre_model.dart';

void main() {
  const tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/backdrop.jpg',
    budget: 100000,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'http://example.com',
    id: 123,
    imdbId: 'imdb123',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 99.9,
    posterPath: '/poster.jpg',
    releaseDate: '2021-01-01',
    revenue: 99999,
    runtime: 120,
    status: 'Released',
    tagline: 'Tag line',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.0,
    voteCount: 1000,
  );

  test('should convert from JSON', () {
    final jsonMap = {
      "adult": false,
      "backdrop_path": "/backdrop.jpg",
      "budget": 100000,
      "genres": [
        {"id": 1, "name": "Action"}
      ],
      "homepage": "http://example.com",
      "id": 123,
      "imdb_id": "imdb123",
      "original_language": "en",
      "original_title": "Original Title",
      "overview": "Overview",
      "popularity": 99.9,
      "poster_path": "/poster.jpg",
      "release_date": "2021-01-01",
      "revenue": 99999,
      "runtime": 120,
      "status": "Released",
      "tagline": "Tag line",
      "title": "Test Movie",
      "video": false,
      "vote_average": 8.0,
      "vote_count": 1000
    };

    final result = MovieDetailResponse.fromJson(jsonMap);
    expect(result, tMovieDetailResponse);
  });

  test('should convert to JSON', () {
    final result = tMovieDetailResponse.toJson();
    expect(result["id"], 123);
    expect(result["genres"], isA<List>());
  });

  test('should convert to entity', () {
    final entity = tMovieDetailResponse.toEntity();
    expect(entity.id, 123);
    expect(entity.title, 'Test Movie');
  });
}