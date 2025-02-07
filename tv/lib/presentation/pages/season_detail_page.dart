import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_event.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_state.dart';
import 'package:tv/presentation/widgets/episode_card.dart';
import 'package:flutter/material.dart';

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
    super.key,
    required this.tvId,
    required this.seasonNumber,
  });

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<SeasonDetailBloc>()
        .add(FetchSeasonDetail(widget.tvId, widget.seasonNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Season ${widget.seasonNumber}'),
      ),
      body: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == RequestState.Loaded) {
            final episodes = state.episodes;
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
            return Center(child: Text(state.message));
          }
        },
      ),
    );
  }
}
