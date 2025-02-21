import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}
class MockGetMovieRecommendations extends Mock implements GetMovieRecommendations {}
class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}
class MockSaveWatchlist extends Mock implements SaveWatchlist {}
class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUpAll(() {
    // registerFallbackValue() opsional jika Anda perlu fallback value di mocktail
    registerFallbackValue(const FetchMovieDetail(1));
  });

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;
  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: tId,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'Title',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieList = <Movie>[
    const Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2],
      id: 2,
      originalTitle: 'Rec Original',
      overview: 'Rec Overview',
      popularity: 1,
      posterPath: 'recPoster',
      releaseDate: 'releaseDate',
      title: 'Rec Title',
      video: false,
      voteAverage: 7.5,
      voteCount: 50,
    )
  ];

  // ----------------------------------------------------------------
  // 1) Pengujian BLoC
  // ----------------------------------------------------------------
  group('MovieDetailBloc test', () {
    group('FetchMovieDetail', () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'should emit [Loading -> detail Loaded -> recommendation Loaded] when all success',
        build: () {
          when(() => mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => const Right(tMovieDetail));
          when(() => mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tMovieList));
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          // 1) detail loading
          const MovieDetailState(movieState: RequestState.Loading),
          // 2) detail loaded
          MovieDetailState(
            movieState: RequestState.Loaded,
            movieDetail: tMovieDetail,
            recommendationState: RequestState.Empty,
            isAddedToWatchlist: false,
          ),
          // 3) recommendations loaded
          MovieDetailState(
            movieState: RequestState.Loaded,
            movieDetail: tMovieDetail,
            recommendationState: RequestState.Loaded,
            recommendations: tMovieList,
            isAddedToWatchlist: false,
          ),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'should emit [Loading, Error] when detail fails',
        build: () {
          when(() => mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => const Left(ServerFailure('Detail fail')));
          // agar tidak MissingStubError
          when(() => mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tMovieList));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          const MovieDetailState(movieState: RequestState.Loading),
          const MovieDetailState(
            movieState: RequestState.Error,
            message: 'Detail fail',
          ),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'should emit detail loaded -> recommendation Error if rec fails',
        build: () {
          when(() => mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => const Right(tMovieDetail));
          when(() => mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => const Left(ServerFailure('Rec fail')));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          const MovieDetailState(movieState: RequestState.Loading),
          MovieDetailState(
            movieState: RequestState.Loaded,
            movieDetail: tMovieDetail,
            isAddedToWatchlist: false,
          ),
          MovieDetailState(
            movieState: RequestState.Loaded,
            movieDetail: tMovieDetail,
            recommendationState: RequestState.Error,
            message: 'Rec fail',
            isAddedToWatchlist: false,
          ),
        ],
      );
    });

    group('Watchlist', () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits 2 states (watchlistMessage -> isAddedToWatchlist=true) when AddWatchlist success',
        build: () {
          when(() => mockSaveWatchlist.execute(tMovieDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add(const AddWatchlist(tMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState(watchlistMessage: 'Added to Watchlist'),
          const MovieDetailState(
            watchlistMessage: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits 1 state (watchlistMessage) when AddWatchlist fails',
        build: () {
          when(() => mockSaveWatchlist.execute(tMovieDetail))
              .thenAnswer((_) async => const Left(DatabaseFailure('Add fail')));
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const AddWatchlist(tMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState(watchlistMessage: 'Add fail'),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits 1 state (watchlistMessage) when RemoveWatchlist success',
        build: () {
          when(() => mockRemoveWatchlist.execute(tMovieDetail))
              .thenAnswer((_) async => const Right('Removed from watchlist'));
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const RemoveFromWatchlist(tMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState(watchlistMessage: 'Removed from watchlist'),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits 1 state (watchlistMessage) when RemoveWatchlist fails',
        build: () {
          when(() => mockRemoveWatchlist.execute(tMovieDetail))
              .thenAnswer((_) async => const Left(DatabaseFailure('Remove fail')));
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const RemoveFromWatchlist(tMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState(watchlistMessage: 'Remove fail'),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits isAddedToWatchlist=true when LoadWatchlistStatus with true',
        build: () {
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
        expect: () => [
          const MovieDetailState(isAddedToWatchlist: true),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits isAddedToWatchlist=false when LoadWatchlistStatus with false',
        build: () {
          when(() => mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
        expect: () => [
          const MovieDetailState(isAddedToWatchlist: false),
        ],
      );
    });
  });

  // ----------------------------------------------------------------
  // 2) Coverage untuk Event
  // ----------------------------------------------------------------
  group('MovieDetailEvent coverage', () {
    test('FetchMovieDetail props', () {
      expect(const FetchMovieDetail(123).props, [123]);
    });

    test('AddWatchlist props', () {
      const testDetail = MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [],
        id: 10,
        originalTitle: 'Original Title',
        overview: 'Overview',
        posterPath: 'posterPath',
        releaseDate: '2023-01-01',
        runtime: 120,
        title: 'Title',
        voteAverage: 8.0,
        voteCount: 100,
      );
      final event = AddWatchlist(testDetail);
      expect(event.props, [testDetail]);
    });

    test('RemoveFromWatchlist props', () {
      const testDetail = MovieDetail(
        adult: false,
        backdropPath: 'backdropPath',
        genres: [],
        id: 10,
        originalTitle: 'Original Title',
        overview: 'Overview',
        posterPath: 'posterPath',
        releaseDate: '2023-01-01',
        runtime: 120,
        title: 'Title',
        voteAverage: 8.0,
        voteCount: 100,
      );
      final event = RemoveFromWatchlist(testDetail);
      expect(event.props, [testDetail]);
    });

    test('LoadWatchlistStatus props', () {
      final event = const LoadWatchlistStatus(99);
      expect(event.props, [99]);
    });
  });

  // ----------------------------------------------------------------
  // 3) Coverage untuk State
  // ----------------------------------------------------------------
  group('MovieDetailState coverage', () {
    test('supports value equality', () {
      expect(const MovieDetailState(), const MovieDetailState());
    });

    test('props test', () {
      const state = MovieDetailState();
      expect(state.props, [
        RequestState.Empty, // movieState
        null,               // movieDetail
        '',                 // message
        RequestState.Empty, // recommendationState
        <Movie>[],          // recommendations
        false,              // isAddedToWatchlist
        '',                 // watchlistMessage
      ]);
    });

    test('copyWith test', () {
      final updatedState = const MovieDetailState().copyWith(
        movieState: RequestState.Loaded,
        movieDetail: tMovieDetail,
        message: 'some message',
        recommendationState: RequestState.Loaded,
        recommendations: tMovieList,
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      );
      expect(updatedState.movieState, RequestState.Loaded);
      expect(updatedState.movieDetail, tMovieDetail);
      expect(updatedState.message, 'some message');
      expect(updatedState.recommendationState, RequestState.Loaded);
      expect(updatedState.recommendations, tMovieList);
      expect(updatedState.isAddedToWatchlist, true);
      expect(updatedState.watchlistMessage, 'Added to Watchlist');
    });
  });
}
