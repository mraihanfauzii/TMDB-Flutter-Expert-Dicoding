import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_state.dart';
import 'package:tv/presentation/pages/on_air_tv_page.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/constants.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/widgets/tv_list.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({super.key});

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvListBloc>().add(FetchTvList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchTvPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildSubHeading(
              title: 'On The Air',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnAirTvPage(),
                ),
              ),
            ),
            BlocBuilder<TvListBloc, TvListState>(builder: (context, state) {
              if (state.onAirState == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.onAirState == RequestState.Loaded) {
                return TvList(state.onAirTvs);
              } else {
                return const Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PopularTvPage(),
                ),
              ),
            ),
            BlocBuilder<TvListBloc, TvListState>(builder: (context, state) {
              if (state.popularState == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.popularState == RequestState.Loaded) {
                return TvList(state.popularTvs);
              } else {
                return const Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TopRatedTvPage(),
                ),
              ),
            ),
            BlocBuilder<TvListBloc, TvListState>(builder: (context, state) {
              if (state.topRatedState == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.topRatedState == RequestState.Loaded) {
                return TvList(state.topRatedTvs);
              } else {
                return const Text('Failed');
              }
            }),
          ]),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
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
    );
  }
}
