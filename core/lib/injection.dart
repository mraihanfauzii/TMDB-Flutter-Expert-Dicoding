import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/utils/ssl/dio_ssl_pinning.dart';
import 'package:dio/dio.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/domain/usecases/search_movies.dart';
// import 'package:movie/presentation/provider/movie_list_notifier.dart';
// import 'package:movie/presentation/provider/movie_search_notifier.dart';
// import 'package:movie/presentation/provider/now_playing_movies_notifier.dart';
// import 'package:movie/presentation/provider/popular_movies_notifier.dart';
// import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
// import 'package:movie/presentation/provider/watchlist_movie_notifier.dart';
// import 'package:movie/presentation/provider/movie_detail_notifier.dart';
// import 'package:tv/presentation/provider/popular_tv_notifier.dart';
// import 'package:tv/presentation/provider/season_detail_notifier.dart';
// import 'package:tv/presentation/provider/top_rated_tv_notifier.dart';
// import 'package:tv/presentation/provider/tv_detail_notifier.dart';
// import 'package:tv/presentation/provider/tv_list_notifier.dart';
// import 'package:tv/presentation/provider/tv_search_notifier.dart';
// import 'package:tv/presentation/provider/watchlist_tv_notifier.dart';
// import 'package:tv/presentation/provider/on_air_tv_notifier.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:get_it/get_it.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_on_air_tvs.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // provider
  // locator.registerFactory(
  //   () => MovieListNotifier(
  //     getNowPlayingMovies: locator(),
  //     getPopularMovies: locator(),
  //     getTopRatedMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => MovieDetailNotifier(
  //     getMovieDetail: locator(),
  //     getMovieRecommendations: locator(),
  //     getWatchListStatus: locator(),
  //     saveWatchlist: locator(),
  //     removeWatchlist: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => MovieSearchNotifier(
  //     searchMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //     () => NowPlayingMoviesNotifier(locator<GetNowPlayingMovies>()));
  // locator.registerFactory(
  //   () => PopularMoviesNotifier(
  //     locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => TopRatedMoviesNotifier(
  //     getTopRatedMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => WatchlistMovieNotifier(
  //     getWatchlistMovies: locator(),
  //   ),
  // );
  //
  // locator.registerFactory(
  //   () => TvListNotifier(
  //     getOnAirTvs: locator(),
  //     getPopularTvs: locator(),
  //     getTopRatedTvs: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => TvDetailNotifier(
  //     getTvDetail: locator(),
  //     getTvRecommendations: locator(),
  //     getWatchListTvStatus: locator(),
  //     saveWatchlistTv: locator(),
  //     removeWatchlistTv: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => OnAirTvNotifier(
  //     getOnAirTvs: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => PopularTvNotifier(
  //     getPopularTvs: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => TopRatedTvNotifier(
  //     getTopRatedTvs: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => TvSearchNotifier(
  //     searchTvs: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => WatchlistTvNotifier(
  //     getWatchlistTvs: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => SeasonDetailNotifier(
  //     remoteDataSource: locator(),
  //   ),
  // );

  // external
  final dio = await createDioWithSSLPinning();
  locator.registerLazySingleton<Dio>(() => dio);

  // Use cases - Movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // Use cases - TV
  locator.registerLazySingleton(() => GetOnAirTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));
  locator.registerLazySingleton(() => GetWatchListTvStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: locator<Dio>()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(dio: locator<Dio>()),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
