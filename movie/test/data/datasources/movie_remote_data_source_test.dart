import 'dart:convert';

import 'package:core/utils/exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_response.dart';

import '../../helpers/json_reader.dart';
import 'movie_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = MovieRemoteDataSourceImpl(dio: mockDio);
  });

  group('getNowPlayingMovies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/now_playing.json')),
    ).movieList;

    test('should return list of Movie Model when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/now_playing?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/now_playing?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/now_playing.json')),
        ),
      );
      // act
      final result = await dataSource.getNowPlayingMovies();
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/now_playing?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/now_playing?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getNowPlayingMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getPopularMovies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/popular.json')),
    ).movieList;

    test('should return list of movies when response is success (200)', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/popular?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/popular?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/popular.json')),
        ),
      );
      // act
      final result = await dataSource.getPopularMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw ServerException when response is not 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/popular?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/popular?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getPopularMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTopRatedMovies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated.json')),
    ).movieList;

    test('should return list of movies when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/top_rated?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/top_rated?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/top_rated.json')),
        ),
      );
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/top_rated?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/top_rated?$apiKey',
          ),
          statusCode: 500,
          data: 'Error',
        ),
      );
      // act
      final call = dataSource.getTopRatedMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getMovieDetail', () {
    const tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
      json.decode(readJson('dummy_data/movie_detail.json')),
    );

    test('should return movie detail when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/$tId?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/$tId?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/movie_detail.json')),
        ),
      );
      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/$tId?$apiKey')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/$tId?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getMovieDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getMovieRecommendations', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movie_recommendations.json')),
    ).movieList;
    const tId = 1;

    test('should return list of Movie Model when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/$tId/recommendations?$apiKey'))
          .thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/$tId/recommendations?$apiKey',
          ),
          statusCode: 200,
          data: json.decode(readJson('dummy_data/movie_recommendations.json')),
        ),
      );
      // act
      final result = await dataSource.getMovieRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/movie/$tId/recommendations?$apiKey'))
          .thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/movie/$tId/recommendations?$apiKey',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.getMovieRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('searchMovies', () {
    final tSearchResult = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/search_spiderman_movie.json')),
    ).movieList;
    const tQuery = 'Spiderman';

    test('should return list of movies when statusCode = 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/search/movie?$apiKey&query=$tQuery'))
          .thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/search/movie?$apiKey&query=$tQuery',
          ),
          statusCode: 200,
          data: json.decode(
            readJson('dummy_data/search_spiderman_movie.json'),
          ),
        ),
      );
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when statusCode != 200', () async {
      // arrange
      when(mockDio.get('$baseUrl/search/movie?$apiKey&query=$tQuery'))
          .thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(
            path: '$baseUrl/search/movie?$apiKey&query=$tQuery',
          ),
          statusCode: 404,
          data: 'Not Found',
        ),
      );
      // act
      final call = dataSource.searchMovies(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
