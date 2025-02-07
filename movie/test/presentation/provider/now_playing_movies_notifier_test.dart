// import 'package:dartz/dartz.dart';
// import 'package:core/utils/failure.dart';
// import 'package:core/utils/state_enum.dart';
// import 'package:movie/domain/entities/movie.dart';
// import 'package:movie/domain/usecases/get_now_playing_movies.dart';
// import 'package:movie/presentation/provider/now_playing_movies_notifier.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// import '../../../test/presentation/provider/now_playing_movies_notifier_test.mocks.dart';
//
// @GenerateMocks([GetNowPlayingMovies])
// void main() {
//   late NowPlayingMoviesNotifier notifier;
//   late MockGetNowPlayingMovies mockGetNowPlayingMovies;
//
//   setUp(() {
//     mockGetNowPlayingMovies = MockGetNowPlayingMovies();
//     notifier = NowPlayingMoviesNotifier(mockGetNowPlayingMovies);
//   });
//
//   final tMovies = <Movie>[
//     const Movie(
//       adult: false,
//       backdropPath: '/backdrop.jpg',
//       genreIds: [1,2],
//       id: 111,
//       originalTitle: 'OriginalTitle1',
//       overview: 'Overview1',
//       popularity: 99.9,
//       posterPath: '/poster1.jpg',
//       releaseDate: '2022-01-01',
//       title: 'Title1',
//       video: false,
//       voteAverage: 7.8,
//       voteCount: 100,
//     ),
//   ];
//
//   test('should change state to Loading then Loaded', () async {
//     when(mockGetNowPlayingMovies.execute())
//         .thenAnswer((_) async => Right(tMovies));
//     await notifier.fetchNowPlayingMovies();
//     expect(notifier.state, RequestState.Loaded);
//     expect(notifier.movies, tMovies);
//   });
//
//   test('should change state to Error when fail', () async {
//     when(mockGetNowPlayingMovies.execute())
//         .thenAnswer((_) async => const Left(ServerFailure('ServerError')));
//     await notifier.fetchNowPlayingMovies();
//     expect(notifier.state, RequestState.Error);
//     expect(notifier.message, 'ServerError');
//   });
// }