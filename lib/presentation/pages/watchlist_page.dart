import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:movie/presentation/widgets/movie_card.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Kirim event untuk mengambil data watchlist
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
    context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
    context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Movies'), Tab(text: 'TV Series')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMoviesWatchlist(), _buildTvWatchlist()],
      ),
    );
  }

  /// Perbaikan:
  /// Di sini kita gunakan properti `movies` pada WatchlistMovieState
  /// karena untuk watchlist movie state kita mendefinisikan daftar film dengan nama `movies`
  Widget _buildMoviesWatchlist() {
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, state) {
        if (state.state == RequestState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == RequestState.Loaded) {
          if (state.movies.isEmpty) {
            return const Center(child: Text('No watchlist movies'));
          }
          return ListView.builder(
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(movie);
            },
          );
        } else {
          return Center(child: Text(state.message));
        }
      },
    );
  }

  /// Untuk watchlist TV, sesuai dengan definisi WatchlistTvState,
  /// daftar TV disimpan di properti `tvs`
  Widget _buildTvWatchlist() {
    return BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
      builder: (context, state) {
        if (state.state == RequestState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == RequestState.Loaded) {
          if (state.tvs.isEmpty) {
            return const Center(child: Text('No watchlist TV series'));
          }
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
    );
  }
}
