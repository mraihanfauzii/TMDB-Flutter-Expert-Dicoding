import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/now_playing_movies_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/pages/on_air_tv_page.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Bloc untuk Movie
        BlocProvider<MovieListBloc>(
          create: (_) => MovieListBloc(
            getNowPlayingMovies: di.locator(),
            getPopularMovies: di.locator(),
            getTopRatedMovies: di.locator(),
          ),
        ),
        BlocProvider<MovieDetailBloc>(
          create: (_) => MovieDetailBloc(
            getMovieDetail: di.locator(),
            getMovieRecommendations: di.locator(),
            getWatchListStatus: di.locator(),
            saveWatchlist: di.locator(),
            removeWatchlist: di.locator(),
          ),
        ),
        BlocProvider<MovieSearchBloc>(
          create: (_) => MovieSearchBloc(searchMovies: di.locator()),
        ),
        BlocProvider<NowPlayingMoviesBloc>(
          create: (_) =>
              NowPlayingMoviesBloc(getNowPlayingMovies: di.locator()),
        ),
        BlocProvider<PopularMoviesBloc>(
          create: (_) => PopularMoviesBloc(getPopularMovies: di.locator()),
        ),
        BlocProvider<TopRatedMoviesBloc>(
          create: (_) => TopRatedMoviesBloc(getTopRatedMovies: di.locator()),
        ),
        BlocProvider<WatchlistMovieBloc>(
          create: (_) => WatchlistMovieBloc(getWatchlistMovies: di.locator()),
        ),
        // Bloc untuk TV
        BlocProvider<TvListBloc>(
          create: (_) => TvListBloc(
            getOnAirTvs: di.locator(),
            getPopularTvs: di.locator(),
            getTopRatedTvs: di.locator(),
          ),
        ),
        BlocProvider<OnAirTvBloc>(
          create: (_) => OnAirTvBloc(getOnAirTvs: di.locator()),
        ),
        BlocProvider<PopularTvBloc>(
          create: (_) => PopularTvBloc(getPopularTvs: di.locator()),
        ),
        BlocProvider<TopRatedTvBloc>(
          create: (_) => TopRatedTvBloc(getTopRatedTvs: di.locator()),
        ),
        BlocProvider<TvDetailBloc>(
          create: (_) => TvDetailBloc(
            getTvDetail: di.locator(),
            getTvRecommendations: di.locator(),
            getWatchListTvStatus: di.locator(),
            saveWatchlistTv: di.locator(),
            removeWatchlistTv: di.locator(),
          ),
        ),
        BlocProvider<TvSearchBloc>(
          create: (_) => TvSearchBloc(searchTvs: di.locator()),
        ),
        BlocProvider<SeasonDetailBloc>(
          create: (_) => SeasonDetailBloc(remoteDataSource: di.locator()),
        ),
        BlocProvider<WatchlistTvBloc>(
          create: (_) => WatchlistTvBloc(getWatchlistTvs: di.locator()),
        ),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: kRichBlack,
            selectedItemColor: kMikadoYellow,
            unselectedItemColor: Colors.white60,
          ),
        ),
        home: const MainPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const MainPage());
            case NowPlayingMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const NowPlayingMoviesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case OnAirTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const OnAirTvPage());
            case PopularTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const PopularTvPage());
            case TopRatedTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const TopRatedTvPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SeasonDetailPage.ROUTE_NAME:
              final args = settings.arguments as SeasonDetailArgs;
              return MaterialPageRoute(
                builder: (_) => SeasonDetailPage(
                    tvId: args.tvId, seasonNumber: args.seasonNumber),
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case SearchTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const SearchTvPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
