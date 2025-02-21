import 'package:dio/dio.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/models/movie_response.dart';
import 'package:core/utils/exception.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await dio.get('$BASE_URL/movie/now_playing?$API_KEY');
    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await dio.get('$BASE_URL/movie/$id?$API_KEY');

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await dio.get(
      '$BASE_URL/movie/$id/recommendations?$API_KEY',
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await dio.get('$BASE_URL/movie/popular?$API_KEY');

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await dio.get('$BASE_URL/movie/top_rated?$API_KEY');

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dio.get(
      '$BASE_URL/search/movie?$API_KEY&query=$query',
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(response.data).movieList;
    } else {
      throw ServerException();
    }
  }
}
