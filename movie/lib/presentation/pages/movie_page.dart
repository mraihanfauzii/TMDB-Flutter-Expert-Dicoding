import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_event.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_state.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_event.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_state.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_event.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/now_playing_movies_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
    context.read<PopularMoviesBloc>().add(FetchPopularMovies());
    context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      NowPlayingMoviesPage.ROUTE_NAME,
                    ),
                child: BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                  builder: (context, state) {
                    if (state.state == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state == RequestState.Loaded) {
                      return MovieHorizontalList(state.movies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      PopularMoviesPage.ROUTE_NAME,
                    ),
                child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                  builder: (context, state) {
                    if (state.state == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state == RequestState.Loaded) {
                      return MovieHorizontalList(state.movies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      TopRatedMoviesPage.ROUTE_NAME,
                    ),
                child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                  builder: (context, state) {
                    if (state.state == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state == RequestState.Loaded) {
                      return MovieHorizontalList(state.movies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubHeading({
    required String title,
    Function()? onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: kHeading6)),
            if (onTap != null)
              InkWell(
                onTap: onTap,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
                  ),
                ),
              ),
          ],
        ),
        child,
      ],
    );
  }
}

class MovieHorizontalList extends StatelessWidget {
  final List<Movie> movies;
  const MovieHorizontalList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                MovieDetailPage.ROUTE_NAME,
                arguments: movie.id,
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
