import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvTable = TvTable(
    id: 1,
    name: 'Test Tv',
    posterPath: '/poster.jpg',
    overview: 'Overview test',
  );

  const tTvDetail = TvDetail(
    id: 1,
    name: 'Test Tv',
    posterPath: '/poster.jpg',
    overview: 'Overview test',
    voteAverage: 8.0,
    genres: [],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [],
  );

  test('should convert from entity', () {
    final result = TvTable.fromEntity(tTvDetail);
    expect(result.id, 1);
    expect(result.name, 'Test Tv');
  });

  test('should convert to entity', () {
    final entity = tTvTable.toEntity();
    expect(entity.id, 1);
    expect(entity.name, 'Test Tv');
  });

  test('should convert to JSON', () {
    final json = tTvTable.toJson();
    expect(json['id'], 1);
    expect(json['name'], 'Test Tv');
  });
}
