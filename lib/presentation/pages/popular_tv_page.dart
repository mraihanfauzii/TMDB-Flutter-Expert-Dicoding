import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';

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
    Future.microtask(() =>
        Provider.of<TvListNotifier>(context, listen: false).fetchPopularTvs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV'),
      ),
      body: Consumer<TvListNotifier>(
        builder: (context, data, child) {
          if (data.popularState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.popularState == RequestState.Loaded) {
            return ListView.builder(
              itemCount: data.popularTvs.length,
              itemBuilder: (context, index) {
                final tv = data.popularTvs[index];
                return TvCard(tv);
              },
            );
          } else {
            return Center(child: Text(data.message));
          }
        },
      ),
    );
  }
}
