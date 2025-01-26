import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTvPage extends StatelessWidget {
  const SearchTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<TvSearchNotifier>(context, listen: false)
                    .fetchTvSearch(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search TV title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            const Text('Search Result', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Consumer<TvSearchNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.state == RequestState.Loaded) {
                    return ListView.builder(
                      itemCount: data.searchResult.length,
                      itemBuilder: (context, index) {
                        final tv = data.searchResult[index];
                        return Container(
                          key: Key('tvSearchResult$index'), // <--- Tambahkan key!
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: TvCard(tv),
                        );
                      },
                    );
                  } else if (data.state == RequestState.Error) {
                    return Center(child: Text(data.message));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
