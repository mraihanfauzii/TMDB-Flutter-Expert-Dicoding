import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final EpisodeModel episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: episode.stillPath != null
                ? '$BASE_IMAGE_URL${episode.stillPath}'
                : 'https://via.placeholder.com/150',
            width: 120,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul, Eps number
                Text(
                  '${episode.episodeNumber}  ${episode.name}',
                  style: kHeading6,
                ),
                const SizedBox(height: 4),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 14, color: Colors.yellowAccent),
                    const SizedBox(width: 4),
                    Text('${(episode.voteAverage * 10).toStringAsFixed(0)}% '),
                    const SizedBox(width: 8),
                    // Rate it! (tombol)
                    ElevatedButton(
                      onPressed: () {
                        // aksi rating? ...
                      },
                      style: ElevatedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      child: const Text('Rate it!'),
                    ),
                    const SizedBox(width: 8),
                    // Tanggal
                    Text(episode.airDate ?? ''),
                  ],
                ),
                // runtime
                if (episode.runtime != null) Text('${episode.runtime}m'),

                // Overview
                if (episode.overview.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(episode.overview),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
