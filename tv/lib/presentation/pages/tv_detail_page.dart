import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';
  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
    context.read<TvDetailBloc>().add(LoadWatchlistTvStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan BlocListener untuk mendeteksi perubahan watchlistMessage dan menampilkan SnackBar
      body: BlocListener<TvDetailBloc, TvDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistMessage != current.watchlistMessage &&
            current.watchlistMessage.isNotEmpty,
        listener: (context, state) {
          final message = state.watchlistMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              // Optional: tambahkan style text jika perlu
            ),
          );
        },
        child: BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            if (state.tvState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.tvState == RequestState.Loaded &&
                state.tvDetail != null) {
              final tv = state.tvDetail!;
              return SafeArea(
                child: DetailContent(
                  tv: tv,
                  recommendations: state.recommendations,
                  isAddedWatchlist: state.isAddedToWatchlist,
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
  final TvDetail tv;
  final List recommendations;
  final bool isAddedWatchlist;

  const DetailContent({
    super.key,
    required this.tv,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Background Poster
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
          width: screenWidth,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        // DraggableScrollableSheet
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
                    // Detail Info
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tv.name, style: kHeading5),
                            // Tombol watchlist
                            ElevatedButton(
                              onPressed: () {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(AddWatchlistTv(tv));
                                } else {
                                  // Perbaikan: panggil event RemoveWatchlistTvEvent tanpa cast
                                  context
                                      .read<TvDetailBloc>()
                                      .add(RemoveWatchlistTvEvent(tv));
                                }
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: kMikadoYellow),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check,
                                          color: kRichBlack)
                                      : const Icon(Icons.add,
                                          color: kRichBlack),
                                  const SizedBox(width: 4),
                                  const Text('Watchlist',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Genres: ${tv.genres.join(', ')}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Episodes: ${tv.numberOfEpisodes}, Seasons: ${tv.numberOfSeasons}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemSize: 24,
                                  itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: kMikadoYellow),
                                ),
                                Text('${tv.voteAverage}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tv.overview),
                            const SizedBox(height: 16),
                            Text('Seasons', style: kHeading6),
                            _buildSeasons(context, tv.seasons),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            _buildRecommendations(context),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 48,
                        height: 4,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Back Button
        Positioned(
          top: 8,
          left: 8,
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

  Widget _buildSeasons(BuildContext context, List<Season> seasons) {
    if (seasons.isEmpty) return const SizedBox();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seasons.length,
      itemBuilder: (context, index) {
        final season = seasons[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              SeasonDetailPage.ROUTE_NAME,
              arguments: SeasonDetailArgs(tv.id, season.seasonNumber),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: season.posterPath != null
                      ? '$BASE_IMAGE_URL${season.posterPath}'
                      : 'https://via.placeholder.com/150',
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        season.name.isNotEmpty
                            ? season.name
                            : 'Untitled Season',
                        style: kHeading6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${season.airDate.split('-').first} • ${season.episodeCount} Episode',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        season.overview.isNotEmpty
                            ? season.overview
                            : 'No overview available.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Colors.yellowAccent),
                          const SizedBox(width: 4),
                          Text(
                              '${(season.voteAverage * 10).toStringAsFixed(0)}%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    if (recommendations.isEmpty) return const SizedBox();
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final tvRec = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tvRec.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: tvRec.posterPath != null
                      ? '$BASE_IMAGE_URL${tvRec.posterPath}'
                      : 'https://via.placeholder.com/150',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
