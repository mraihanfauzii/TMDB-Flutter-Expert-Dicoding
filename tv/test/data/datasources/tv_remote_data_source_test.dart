import 'dart:convert';

import 'package:core/utils/exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/season_detail_response.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';

import '../../helpers/json_reader.dart';
import 'tv_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = TvRemoteDataSourceImpl(dio: mockDio);
  });

  group('getOnAirTvs', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/on_air_tv.json')),
    ).tvList;

    test('should return list of TvModel when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/on_the_air?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/on_the_air?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/on_air_tv.json')),
        ),
      );
      // act
      final result = await dataSource.getOnAirTvs();
      // assert
      expect(result, isA<List<TvModel>>());
      expect(result, tTvList);
    });

    test('should throw a ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/on_the_air?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/on_the_air?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getOnAirTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getPopularTvs', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
    ).tvList;

    test('should return list of TvModel when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/popular?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/popular?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/popular_tv.json')),
        ),
      );
      // act
      final result = await dataSource.getPopularTvs();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/popular?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/popular?$apiKey',
          ),
          statusCode: 500,
          data: 'Error',
        ),
      );
      // act
      final call = dataSource.getPopularTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTopRatedTvs', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv.json')),
    ).tvList;

    test('should return list of TvModel when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/top_rated?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/top_rated?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/top_rated_tv.json')),
        ),
      );
      // act
      final result = await dataSource.getTopRatedTvs();
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/top_rated?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/top_rated?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getTopRatedTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTvDetail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return TvDetailResponse when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/$tId?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/$tId?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/tv_detail.json')),
        ),
      );
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, tTvDetail);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/$tId?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/$tId?$apiKey',
          ),
          statusCode: 500,
          data: 'Error',
        ),
      );
      // act
      final call = dataSource.getTvDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTvRecommendations', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;
    const tId = 1;

    test('should return list of TvModel if success (200)', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/$tId/recommendations?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/$tId/recommendations?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/tv_recommendations.json')),
        ),
      );
      // act
      final result = await dataSource.getTvRecommendations(tId);
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/$tId/recommendations?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/$tId/recommendations?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getTvRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('searchTvs', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/search_kraven_tv.json')),
    ).tvList;
    const tQuery = 'kraven';

    test('should return list of TvModel if success (200)', () async {
      // arrange
      when(mockDio.get('$baseUrl/search/tv?$apiKey&query=$tQuery')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/search/tv?$apiKey&query=$tQuery',
          ),
          statusCode: 200,
          data: json.decode(
            readJson('dummy_data/search_kraven_tv.json'),
          ),
        ),
      );
      // act
      final result = await dataSource.searchTvs(tQuery);
      // assert
      expect(result, tTvList);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/search/tv?$apiKey&query=$tQuery')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/search/tv?$apiKey&query=$tQuery',
          ),
          statusCode: 500,
          data: 'Error',
        ),
      );
      // act
      final call = dataSource.searchTvs(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getSeasonDetail', () {
    const tvId = 777;
    const seasonNum = 2;
    final tSeasonDetail = SeasonDetailResponse.fromJson(
      json.decode(readJson('dummy_data/season_detail.json')),
    );

    test('should return SeasonDetailResponse if success (200)', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/$tvId/season/$seasonNum?$apiKey'))
          .thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/$tvId/season/$seasonNum?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/season_detail.json')),
        ),
      );
      // act
      final result = await dataSource.getSeasonDetail(tvId, seasonNum);
      // assert
      expect(result, tSeasonDetail);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/tv/$tvId/season/$seasonNum?$apiKey'))
          .thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/tv/$tvId/season/$seasonNum?$apiKey',
          ),
          statusCode: 404,
          data: 'Error',
        ),
      );
      // act
      final call = dataSource.getSeasonDetail(tvId, seasonNum);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
