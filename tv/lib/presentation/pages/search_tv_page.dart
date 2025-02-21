import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';
import 'package:tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  const SearchTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TvSearchBloc>().add(FetchTvSearch(query));
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
              child: BlocBuilder<TvSearchBloc, TvSearchState>(
                builder: (context, state) {
                  if (state.state == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.state == RequestState.Loaded) {
                    return ListView.builder(
                      itemCount: state.tvs.length,
                      itemBuilder: (context, index) {
                        final tv = state.tvs[index];
                        return Container(
                          key: Key(
                            'tvSearchResult$index',
                          ), // <--- Tambahkan key!
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: TvCard(tv),
                        );
                      },
                    );
                  } else if (state.state == RequestState.Error) {
                    return Center(child: Text(state.message));
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
