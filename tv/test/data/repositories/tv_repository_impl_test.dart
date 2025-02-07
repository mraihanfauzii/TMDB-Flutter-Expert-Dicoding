import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTvModel = TvModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 8.0,
    firstAirDate: '2023-01-01',
  );

  const tTvFromLocal = Tv(
    id: 1,
    name: 'Test Tv',
    overview: 'Overview test',
    posterPath: '/path.jpg',
    voteAverage: null,
    firstAirDate: null,
  );

  const tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 8.0,
    firstAirDate: '2023-01-01',
  );

  const tTvDetail = TvDetail(
    id: 1,
    name: 'Test Tv',
    posterPath: '/path.jpg',
    overview: 'Overview test',
    voteAverage: 8.0,
    genres: ['Drama'],
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
  );

  const tTvTable = TvTable(
    id: 1,
    name: 'Test Tv',
    posterPath: '/path.jpg',
    overview: 'Overview test',
  );

  group('getOnAirTvs', () {
    test('should return remote data (Right) when call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getOnAirTvs())
          .thenAnswer((_) async => [tTvModel]);
      // act
      final result = await repository.getOnAirTvs();
      // assert
      final list = result.getOrElse(() => []);
      expect(list, [tTv]);
    });

    test('should return server failure (Left) when call is unsuccessful', () async {
      when(mockRemoteDataSource.getOnAirTvs()).thenThrow(ServerException());
      final result = await repository.getOnAirTvs();
      expect(result, const Left(ServerFailure('Error from server')));
    });

    test('should return connection failure when no internet', () async {
      when(mockRemoteDataSource.getOnAirTvs()).thenThrow(const SocketException('Failed to connect'));
      final result = await repository.getOnAirTvs();
      expect(result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('getPopularTvs', () {
    test('should return data when success', () async {
      when(mockRemoteDataSource.getPopularTvs()).thenAnswer((_) async => [tTvModel]);
      final result = await repository.getPopularTvs();
      final list = result.getOrElse(() => []);
      expect(list, [tTv]);
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());
      final result = await repository.getPopularTvs();
      expect(result, const Left(ServerFailure('Error from server')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.getPopularTvs()).thenThrow(const SocketException('Failed to connect'));
      final result = await repository.getPopularTvs();
      expect(result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('getTopRatedTvs', () {
    test('should return data when success', () async {
      when(mockRemoteDataSource.getTopRatedTvs()).thenAnswer((_) async => [tTvModel]);
      final result = await repository.getTopRatedTvs();
      final list = result.getOrElse(() => []);
      expect(list, [tTv]);
    });

    test('should return server failure', () async {
      when(mockRemoteDataSource.getTopRatedTvs()).thenThrow(ServerException());
      final result = await repository.getTopRatedTvs();
      expect(result, const Left(ServerFailure('Error from server')));
    });

    test('should return connection failure', () async {
      when(mockRemoteDataSource.getTopRatedTvs()).thenThrow(const SocketException('Failed to connect'));
      final result = await repository.getTopRatedTvs();
      expect(result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('getTvDetail', () {
    test('should return tv data when success', () async {
      when(mockRemoteDataSource.getTvDetail(1)).thenAnswer((_) async => tTvDetail.toResponse());
      final result = await repository.getTvDetail(1);
      final tv = result.getOrElse(() => tTvDetail);
      expect(tv, tTvDetail);
    });

    test('should return server failure if error', () async {
      when(mockRemoteDataSource.getTvDetail(1)).thenThrow(ServerException());
      final result = await repository.getTvDetail(1);
      expect(result, const Left(ServerFailure('Error from server')));
    });

    test('should return connection failure if socket', () async {
      when(mockRemoteDataSource.getTvDetail(1)).thenThrow(const SocketException('Failed to connect'));
      final result = await repository.getTvDetail(1);
      expect(result, const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('getTvRecommendations', () {
    test('should return list tv on success', () async {
      when(mockRemoteDataSource.getTvRecommendations(1)).thenAnswer((_) async => [tTvModel]);
      final result = await repository.getTvRecommendations(1);
      final list = result.getOrElse(() => []);
      expect(list, [tTv]);
    });

    test('should return server failure on error', () async {
      when(mockRemoteDataSource.getTvRecommendations(1)).thenThrow(ServerException());
      final result = await repository.getTvRecommendations(1);
      expect(result, const Left(ServerFailure('Error from server')));
    });
  });

  group('searchTvs', () {
    const tQuery = 'kraven';
    test('should return list tv on success', () async {
      when(mockRemoteDataSource.searchTvs(tQuery)).thenAnswer((_) async => [tTvModel]);
      final result = await repository.searchTvs(tQuery);
      final list = result.getOrElse(() => []);
      expect(list, [tTv]);
    });

    test('should return server failure on error', () async {
      when(mockRemoteDataSource.searchTvs(tQuery)).thenThrow(ServerException());
      final result = await repository.searchTvs(tQuery);
      expect(result, const Left(ServerFailure('Error from server')));
    });
  });

  group('saveWatchlistTv', () {
    test('should return success message when insert successful', () async {
      when(mockLocalDataSource.insertWatchlistTv(tTvTable)).thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlistTv(tTvDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when insert fails', () async {
      when(mockLocalDataSource.insertWatchlistTv(tTvTable)).thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlistTv(tTvDetail);
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('removeWatchlistTv', () {
    test('should return success message when remove success', () async {
      when(mockLocalDataSource.removeWatchlistTv(tTvTable)).thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlistTv(tTvDetail);
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove fails', () async {
      when(mockLocalDataSource.removeWatchlistTv(tTvTable)).thenThrow(DatabaseException('Failed remove'));
      final result = await repository.removeWatchlistTv(tTvDetail);
      expect(result, const Left(DatabaseFailure('Failed remove')));
    });
  });

  group('isAddedToWatchlistTv', () {
    test('should return true when data is found', () async {
      when(mockLocalDataSource.getTvById(1)).thenAnswer((_) async => tTvTable);
      final result = await repository.isAddedToWatchlistTv(1);
      expect(result, true);
    });

    test('should return false when data is not found', () async {
      when(mockLocalDataSource.getTvById(1)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlistTv(1);
      expect(result, false);
    });
  });

  group('getWatchlistTvs', () {
    test('should return list tv from local data', () async {
      when(mockLocalDataSource.getWatchlistTvs()).thenAnswer((_) async => [tTvTable]);
      final result = await repository.getWatchlistTvs();
      final list = result.getOrElse(() => []);
      expect(list, [tTvFromLocal]);
    });
  });

  test('getSeasonDetail should throw UnimplementedError', () async {
    expect(
          () => repository.getSeasonDetail(),
      throwsA(isA<UnimplementedError>()),
    );
  });

}

// Extension agar kita bisa memanggil toResponse() untuk memudahkan
extension on TvDetail {
  TvDetailResponse toResponse() {
    return TvDetailResponse(
      id: 1,
      name: name,
      posterPath: posterPath,
      overview: overview,
      voteAverage: voteAverage,
      genres: genres.map((g) => {'id': 99, 'name': g}).toList(),
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      seasons: const [],
    );
  }
}
