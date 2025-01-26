import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  const tTvTable = TvTable(
    id: 1,
    name: 'Test Tv',
    posterPath: '/path.jpg',
    overview: 'Overview test',
  );

  group('insertWatchlistTv', () {
    test('should return success message when insert to database is success', () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTv(tTvTable)).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlistTv(tTvTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed', () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTv(tTvTable)).thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlistTv(tTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('removeWatchlistTv', () {
    test('should return success message when remove from database is success', () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTv(tTvTable)).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlistTv(tTvTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove fails', () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTv(tTvTable)).thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlistTv(tTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('getTvById', () {
    const tId = 1;
    test('should return TvTable when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => {
        'id': 1,
        'name': 'Test Tv',
        'posterPath': '/path.jpg',
        'overview': 'Overview test',
      });
      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, tTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, null);
    });
  });

  group('getWatchlistTvs', () {
    test('should return list of TvTable from db', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvs()).thenAnswer((_) async => [
        {
          'id': 1,
          'name': 'Test Tv',
          'posterPath': '/path.jpg',
          'overview': 'Overview test',
        }
      ]);
      // act
      final result = await dataSource.getWatchlistTvs();
      // assert
      expect(result, [tTvTable]);
    });
  });
}