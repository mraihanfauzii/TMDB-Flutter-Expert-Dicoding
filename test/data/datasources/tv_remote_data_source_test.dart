import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/season_detail_response.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getOnAirTvs', () {
    test('should return list of TvModel when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('https://api.themoviedb.org/3/tv/on_the_air?api_key=2174d146bb9c0eab47529b2e77d6b526')),
      ).thenAnswer((_) async => http.Response(
        jsonEncode({
          "results": [
            {
              "id": 1,
              "name": "Mock On Air TV",
              "overview": "Overview...",
              "poster_path": "/path.jpg",
              "vote_average": 7.8,
              "first_air_date": "2023-01-01"
            }
          ]
        }),
        200,
      ));
      // act
      final result = await dataSource.getOnAirTvs();
      // assert
      expect(result, isA<List<TvModel>>());
      expect(result.length, 1);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getOnAirTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getPopularTvs', () {
    test('should return list of TvModel when response is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.themoviedb.org/3/tv/popular?api_key=2174d146bb9c0eab47529b2e77d6b526')))
          .thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            "results": [
              {
                "id": 2,
                "name": "Mock Popular TV",
                "overview": "Overview popular",
                "poster_path": "/path_pop.jpg",
                "vote_average": 7.5,
                "first_air_date": "2022-11-11"
              }
            ]
          }),
          200,
        ),
      );
      // act
      final result = await dataSource.getPopularTvs();
      // assert
      expect(result.length, 1);
    });

    test('should throw ServerException if error', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 500));
      // act
      final call = dataSource.getPopularTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTopRatedTvs', () {
    test('should return list of TvModel if success', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('https://api.themoviedb.org/3/tv/top_rated?api_key=2174d146bb9c0eab47529b2e77d6b526')))
          .thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            "results": [
              {
                "id": 3,
                "name": "Mock Top Rated TV",
                "overview": "Overview top rated",
                "poster_path": "/path_top.jpg",
                "vote_average": 9.0,
                "first_air_date": "2021-05-05"
              }
            ]
          }),
          200,
        ),
      );
      // act
      final result = await dataSource.getTopRatedTvs();
      // assert
      expect(result.length, 1);
    });

    test('should throw ServerException if fail', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 404));
      final call = dataSource.getTopRatedTvs();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTvDetail', () {
    const tId = 1;
    test('should return TvDetailResponse when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('https://api.themoviedb.org/3/tv/$tId?api_key=2174d146bb9c0eab47529b2e77d6b526')),
      ).thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            "id": 1,
            "name": "Mock Tv",
            "overview": "Overview",
            "poster_path": "/path.jpg",
            "vote_average": 8.0,
            "genres": [
              {"id": 18, "name": "Drama"}
            ],
            "number_of_episodes": 10,
            "number_of_seasons": 1
          }),
          200,
        ),
      );
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, isA<TvDetailResponse>());
      expect(result.id, tId);
    });

    test('should throw ServerException when code != 200', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 500));
      // act
      final call = dataSource.getTvDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getTvRecommendations', () {
    const tId = 1;
    test('should return list of TvModel if success', () async {
      when(mockHttpClient.get(Uri.parse('https://api.themoviedb.org/3/tv/$tId/recommendations?api_key=2174d146bb9c0eab47529b2e77d6b526')))
          .thenAnswer((_) async => http.Response(
        jsonEncode({
          "results": [
            {
              "id": 99,
              "name": "Mock Recommendation",
              "overview": "Overview rec",
              "poster_path": "/path_rec.jpg",
              "vote_average": 6.7
            }
          ]
        }),
        200,
      ));
      final result = await dataSource.getTvRecommendations(tId);
      expect(result.length, 1);
    });

    test('should throw ServerException if fail', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 404));
      final call = dataSource.getTvRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('searchTvs', () {
    const tQuery = 'kraven';
    test('should return list of TvModel if success', () async {
      when(mockHttpClient.get(Uri.parse(
          'https://api.themoviedb.org/3/search/tv?api_key=2174d146bb9c0eab47529b2e77d6b526&query=$tQuery')))
          .thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            "results": [
              {
                "id": 101,
                "name": "Kraven Series",
                "overview": "Overview search",
                "poster_path": "/path_kraven.jpg",
                "vote_average": 5.5
              }
            ]
          }),
          200,
        ),
      );

      final result = await dataSource.searchTvs(tQuery);
      expect(result.length, 1);
    });

    test('should throw ServerException if error', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 500));
      final call = dataSource.searchTvs(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  // Tambahan group test => getSeasonDetail
  group('getSeasonDetail', () {
    const tvId = 777;
    const seasonNum = 2;
    test('should return SeasonDetailResponse if success', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('https://api.themoviedb.org/3/tv/$tvId/season/$seasonNum?api_key=2174d146bb9c0eab47529b2e77d6b526')),
      ).thenAnswer(
            (_) async => http.Response(
          jsonEncode({
            "id": 555,
            "name": "Season 2",
            "episodes": [
              {
                "id": 9999,
                "name": "Episode 1",
                "episode_number": 1,
                "vote_average": 8.1
              },
            ],
          }),
          200,
        ),
      );
      // act
      final result = await dataSource.getSeasonDetail(tvId, seasonNum);
      // assert
      expect(result, isA<SeasonDetailResponse>());
      expect(result.id, 555);
      expect(result.episodes.length, 1);
    });

    test('should throw ServerException if fail', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getSeasonDetail(tvId, seasonNum);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
