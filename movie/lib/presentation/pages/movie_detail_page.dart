import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';
  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
    context.read<MovieDetailBloc>().add(LoadWatchlistStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MovieDetailBloc, MovieDetailState>(
        listenWhen:
            (previous, current) =>
                previous.watchlistMessage != current.watchlistMessage &&
                current.watchlistMessage.isNotEmpty,
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message == 'Added to Watchlist' ||
              message == 'Removed from Watchlist') {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(content: Text(message)),
            );
          }
        },
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state.movieState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.movieState == RequestState.Loaded &&
                state.movieDetail != null) {
              return SafeArea(
                child: DetailContent(
                  movie: state.movieDetail!,
                  recommendations: state.recommendations,
                  isAddedWatchlist: state.isAddedToWatchlist,
                  recommendationState: state.recommendationState,
                  recommendationErrorMessage: state.message,
                ),
              );
            } else {
              return Center(child: Text(state.message));
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;
  final RequestState recommendationState;
  final String recommendationErrorMessage;

  const DetailContent({
    super.key,
    required this.movie,
    required this.recommendations,
    required this.isAddedWatchlist,
    required this.recommendationState,
    required this.recommendationErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder:
              (context, url) =>
                  const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: kHeading5),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kMikadoYellow,
                              ),
                              onPressed: () {
                                if (!isAddedWatchlist) {
                                  context.read<MovieDetailBloc>().add(
                                    AddWatchlist(movie),
                                  );
                                } else {
                                  context.read<MovieDetailBloc>().add(
                                    RemoveFromWatchlist(movie),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(
                                        Icons.check,
                                        color: kRichBlack,
                                      )
                                      : const Icon(
                                        Icons.add,
                                        color: kRichBlack,
                                      ),
                                  const Text(
                                    'Watchlist',
                                    style: TextStyle(color: kRichBlack),
                                  ),
                                ],
                              ),
                            ),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder:
                                      (context, index) => const Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(movie.overview),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            Builder(
                              builder: (context) {
                                if (recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      key: const Key('recommendation_loading'),
                                    ),
                                  );
                                } else if (recommendationState ==
                                    RequestState.Error) {
                                  return Text(recommendationErrorMessage);
                                } else if (recommendationState ==
                                    RequestState.Loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recommendations.length,
                                      itemBuilder: (context, index) {
                                        final movieRec = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            key: Key(
                                              'recommendation_item_$index',
                                            ),
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.ROUTE_NAME,
                                                arguments: movieRec.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movieRec.posterPath}',
                                                placeholder:
                                                    (
                                                      context,
                                                      url,
                                                    ) => const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Tombol back
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) =>
      genres.map((g) => g.name).join(', ');

  String _showDuration(int runtime) {
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
