// test/presentation/pages/now_playing_movies_page_test.dart
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/now_playing_movies_page.dart';
import 'package:ditonton/presentation/provider/now_playing_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'now_playing_movies_page_test.mocks.dart';

@GenerateMocks([NowPlayingMoviesNotifier])
void main() {
  late MockNowPlayingMoviesNotifier mockNotifier;

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<NowPlayingMoviesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  setUp(() {
    mockNotifier = MockNowPlayingMoviesNotifier();
  });

  testWidgets('should display CircularProgressIndicator when loading', (tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded', (tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.movies).thenReturn([
      const Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2],
        id: 100,
        originalTitle: 'Original Title 1',
        overview: 'Overview 1',
        popularity: 99.9,
        posterPath: '/poster1.jpg',
        releaseDate: '2022-01-01',
        title: 'Test Title 1',
        video: false,
        voteAverage: 7.8,
        voteCount: 100,
      ),
      const Movie(
        adult: false,
        backdropPath: '/backdrop2.jpg',
        genreIds: [3, 4],
        id: 101,
        originalTitle: 'Original Title 2',
        overview: 'Overview 2',
        popularity: 88.8,
        posterPath: '/poster2.jpg',
        releaseDate: '2022-02-02',
        title: 'Test Title 2',
        video: false,
        voteAverage: 8.2,
        voteCount: 200,
      ),
    ]);

    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });
}