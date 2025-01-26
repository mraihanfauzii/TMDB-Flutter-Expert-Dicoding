import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';
  final int id;

  const TvDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<TvDetailNotifier>(context, listen: false);
      provider.fetchTvDetail(widget.id);
      provider.loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: DetailContent(
                tv: tv,
                recommendations: provider.tvRecommendations,
                isAddedWatchlist: provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Center(child: Text(provider.message));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List recommendations;
  final bool isAddedWatchlist;

  const DetailContent({
    Key? key,
    required this.tv,
    required this.recommendations,
    required this.isAddedWatchlist,
  }) : super(key: key);

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
                    // isi detail
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(tv.name, style: kHeading5),
                            // watchlist button
                            FilledButton(
                              onPressed: () async {
                                final notifier = Provider.of<TvDetailNotifier>(
                                    context,
                                    listen: false);
                                if (!isAddedWatchlist) {
                                  await notifier.addWatchlist(tv);
                                } else {
                                  await notifier.removeFromWatchlist(tv);
                                }
                                final message = notifier.watchlistMessage;
                                if (message ==
                                        TvDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(content: Text(message)),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: kMikadoYellow),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            // genres
                            const SizedBox(height: 8),
                            Text(
                              'Genres: ${tv.genres.join(', ')}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            // episodes & seasons
                            Text(
                              'Episodes: ${tv.numberOfEpisodes}, Seasons: ${tv.numberOfSeasons}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            // rating
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemSize: 24,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                ),
                                Text(
                                  '${tv.voteAverage}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            // overview
                            Text('Overview', style: kHeading6),
                            Text(tv.overview),
                            const SizedBox(height: 16),
                            // Seasons
                            Text('Seasons', style: kHeading6),
                            _buildSeasons(context, tv.seasons),
                            const SizedBox(height: 16),
                            // recommendations
                            Text('Recommendations', style: kHeading6),
                            _buildRecommendations(context),
                          ],
                        ),
                      ),
                    ),
                    // garis tip
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

        // back button
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
    if (seasons.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seasons.length,
      itemBuilder: (context, index) {
        final season = seasons[index];
        // buat card menampilkan gambar, judul, rating, dsb
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
                // Poster
                CachedNetworkImage(
                  imageUrl: season.posterPath != null
                      ? '$BASE_IMAGE_URL${season.posterPath}'
                      : 'https://via.placeholder.com/150',
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                // Info
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
    if (recommendations.isEmpty) {
      return const SizedBox();
    }
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
