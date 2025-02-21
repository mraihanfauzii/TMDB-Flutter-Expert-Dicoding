import 'package:core/utils/exception.dart';
import 'package:dio/dio.dart';
import 'package:tv/data/models/season_detail_response.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnAirTvs();
  Future<List<TvModel>> getPopularTvs();
  Future<List<TvModel>> getTopRatedTvs();
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTvs(String query);
  Future<SeasonDetailResponse> getSeasonDetail(int tvId, int seasonNumber);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final Dio dio;

  TvRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TvModel>> getOnAirTvs() async {
    final response = await dio.get('$BASE_URL/tv/on_the_air?$API_KEY');
    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvs() async {
    final response = await dio.get('$BASE_URL/tv/popular?$API_KEY');
    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvs() async {
    final response = await dio.get('$BASE_URL/tv/top_rated?$API_KEY');
    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final response = await dio.get('$BASE_URL/tv/$id?$API_KEY');
    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response = await dio.get('$BASE_URL/tv/$id/recommendations?$API_KEY');
    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvs(String query) async {
    final response = await dio.get('$BASE_URL/search/tv?$API_KEY&query=$query');
    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailResponse> getSeasonDetail(
    int tvId,
    int seasonNumber,
  ) async {
    final response = await dio.get(
      '$BASE_URL/tv/$tvId/season/$seasonNumber?$API_KEY',
    );
    if (response.statusCode == 200) {
      return SeasonDetailResponse.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
