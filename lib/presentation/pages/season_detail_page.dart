import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/season_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/episode_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonDetailArgs {
  final int tvId;
  final int seasonNumber;
  SeasonDetailArgs(this.tvId, this.seasonNumber);
}

class SeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/season-detail';

  final int tvId;
  final int seasonNumber;

  const SeasonDetailPage({
    Key? key,
    required this.tvId,
    required this.seasonNumber,
  }) : super(key: key);

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SeasonDetailNotifier>(context, listen: false)
          .fetchSeasonDetail(widget.tvId, widget.seasonNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Season ${widget.seasonNumber}'),
      ),
      body: Consumer<SeasonDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == RequestState.Loaded) {
            final episodes = provider.episodes;
            if (episodes.isEmpty) {
              return const Center(child: Text('No episodes found.'));
            }
            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final ep = episodes[index];
                return EpisodeCard(episode: ep);
              },
            );
          } else {
            return Center(child: Text(provider.message));
          }
        },
      ),
    );
  }
}
