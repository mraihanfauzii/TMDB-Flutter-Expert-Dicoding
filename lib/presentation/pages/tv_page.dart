import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/on_air_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/widgets/tv_list.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({super.key});

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final tvProvider = Provider.of<TvListNotifier>(context, listen: false);
      tvProvider.fetchOnAirTvs();
      tvProvider.fetchPopularTvs();
      tvProvider.fetchTopRatedTvs();
    });
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
            Consumer<TvListNotifier>(builder: (context, data, child) {
              if (data.onAirState == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (data.onAirState == RequestState.Loaded) {
                return TvList(data.onAirTvs);
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
            Consumer<TvListNotifier>(builder: (context, data, child) {
              if (data.popularState == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (data.popularState == RequestState.Loaded) {
                return TvList(data.popularTvs);
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
            Consumer<TvListNotifier>(builder: (context, data, child) {
              if (data.topRatedState == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (data.topRatedState == RequestState.Loaded) {
                return TvList(data.topRatedTvs);
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
