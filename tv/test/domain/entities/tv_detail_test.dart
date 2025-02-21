import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv_detail.dart';

void main() {
  final tDetail = TvDetail(
    id: 1,
    name: 'Test Tv',
    posterPath: '/poster.jpg',
    overview: 'Overview test',
    voteAverage: 7.8,
    genres: ['Drama', 'Mystery'],
    numberOfEpisodes: 22,
    numberOfSeasons: 3,
    seasons: [
      const Season(
        airDate: '2023-01-01',
        episodeCount: 9,
        id: 201,
        name: 'Season 1',
        overview: 'Overview S1',
        posterPath: '/season1.jpg',
        seasonNumber: 1,
        voteAverage: 8.0,
      ),
    ],
  );

  group('TvDetail entity test', () {
    test('props should contain correct data', () {
      expect(tDetail.props, [
        1,
        'Test Tv',
        '/poster.jpg',
        'Overview test',
        7.8,
        ['Drama', 'Mystery'],
        22,
        3,
        tDetail.seasons,
      ]);
    });

    test('copyWith should return new instance with updated fields', () {
      final updated = tDetail.copyWith(
        name: 'New Tv',
        voteAverage: 9.2,
        genres: ['Comedy'],
        seasons: [],
      );
      expect(updated.id, 1);
      expect(updated.name, 'New Tv');
      expect(updated.voteAverage, 9.2);
      expect(updated.genres, ['Comedy']);
      expect(updated.seasons.length, 0);
      expect(updated.posterPath, '/poster.jpg'); // unchanged
    });
  });
}

extension on TvDetail {
  TvDetail copyWith({
    int? id,
    String? name,
    String? posterPath,
    String? overview,
    double? voteAverage,
    List<String>? genres,
    int? numberOfEpisodes,
    int? numberOfSeasons,
    List<Season>? seasons,
  }) {
    return TvDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      genres: genres ?? this.genres,
      numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      seasons: seasons ?? this.seasons,
    );
  }
}
