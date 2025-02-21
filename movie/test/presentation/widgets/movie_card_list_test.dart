import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/widgets/movie_card.dart';
import 'package:movie/presentation/widgets/movie_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display list of MovieCard', (WidgetTester tester) async {
    final movies = [
      const Movie(
        adult: false,
        backdropPath: '/backdrop1.jpg',
        genreIds: [1,2],
        id: 111,
        originalTitle: 'OriginalTitle1',
        overview: 'Overview1',
        popularity: 99.9,
        posterPath: '/poster1.jpg',
        releaseDate: '2022-01-01',
        title: 'Title1',
        video: false,
        voteAverage: 8.0,
        voteCount: 100,
      ),
      const Movie(
        adult: false,
        backdropPath: '/backdrop2.jpg',
        genreIds: [3,4],
        id: 222,
        originalTitle: 'OriginalTitle2',
        overview: 'Overview2',
        popularity: 88.8,
        posterPath: '/poster2.jpg',
        releaseDate: '2022-02-02',
        title: 'Title2',
        video: false,
        voteAverage: 7.5,
        voteCount: 200,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieList(movies),
        ),
      ),
    );
    await tester.pump();

    // Verifikasi
    expect(find.byType(MovieCard), findsNWidgets(2));
  });
}