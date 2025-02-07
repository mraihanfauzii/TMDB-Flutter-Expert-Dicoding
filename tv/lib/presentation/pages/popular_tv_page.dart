import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';
import 'package:tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/state_enum.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTvPage({super.key});

  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularTvBloc>().add(FetchPopularTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV'),
      ),
      body: BlocBuilder<PopularTvBloc, PopularTvState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == RequestState.Loaded) {
            return ListView.builder(
              itemCount: state.tvs.length,
              itemBuilder: (context, index) {
                final tv = state.tvs[index];
                return TvCard(tv);
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
