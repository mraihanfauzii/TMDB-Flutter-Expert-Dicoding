import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies(),
    );
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingMoviesPage.ROUTE_NAME),
                child: Consumer<MovieListNotifier>(
                  builder: (context, data, child) {
                    if (data.nowPlayingState == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (data.nowPlayingState == RequestState.Loaded) {
                      return MovieHorizontalList(data.nowPlayingMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
                child: Consumer<MovieListNotifier>(
                  builder: (context, data, child) {
                    if (data.popularMoviesState == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (data.popularMoviesState == RequestState.Loaded) {
                      return MovieHorizontalList(data.popularMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
                child: Consumer<MovieListNotifier>(
                  builder: (context, data, child) {
                    if (data.topRatedMoviesState == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (data.topRatedMoviesState ==
                        RequestState.Loaded) {
                      return MovieHorizontalList(data.topRatedMovies);
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
            Expanded(
              child: Text(title, style: kHeading6),
            ),
            if (onTap != null)
              InkWell(
                onTap: onTap,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('See More'),
                    Icon(Icons.arrow_forward_ios),
                  ]),
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
              Navigator.pushNamed(context, MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id);
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
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
