import 'package:tv/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeason = Season(
    airDate: '2021-09-17',
    episodeCount: 9,
    id: 999,
    name: 'Season 1',
    overview: 'Overview season1',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    voteAverage: 8.0,
  );

  test('props should contain correct fields', () {
    expect(
      tSeason.props,
      [
        '2021-09-17',
        9,
        999,
        'Season 1',
        'Overview season1',
        '/poster.jpg',
        1,
        8.0,
      ],
    );
  });
}
