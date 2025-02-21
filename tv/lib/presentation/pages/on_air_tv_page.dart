import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_event.dart';
import 'package:tv/presentation/bloc/on_air_tv/on_air_tv_state.dart';
import 'package:tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/state_enum.dart';

class OnAirTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-air-tv';

  const OnAirTvPage({super.key});

  @override
  State<OnAirTvPage> createState() => _OnAirTvPageState();
}

class _OnAirTvPageState extends State<OnAirTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnAirTvBloc>().add(FetchOnAirTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnAirTvBloc, OnAirTvState>(
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
            } else if (state.state == RequestState.Error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No Data'));
            }
          },
        ),
      ),
    );
  }
}
