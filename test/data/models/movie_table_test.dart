import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMovieTable = MovieTable(
    id: 1,
    title: 'Title',
    posterPath: '/poster.jpg',
    overview: 'Overview',
  );

  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/back.jpg',
    genres: [],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    releaseDate: '2022-01-01',
    runtime: 120,
    title: 'Title',
    voteAverage: 7.5,
    voteCount: 99,
  );

  test('should be able to convert from entity', () {
    final result = MovieTable.fromEntity(tMovieDetail);
    expect(result.id, 1);
    expect(result.title, 'Title');
  });

  test('should be able to convert to entity', () {
    final result = tMovieTable.toEntity();
    expect(result, isA<Movie>());
    expect(result.id, 1);
  });

  test('should be able to convert to JSON', () {
    final json = tMovieTable.toJson();
    expect(json['id'], 1);
    expect(json['title'], 'Title');
  });
}
