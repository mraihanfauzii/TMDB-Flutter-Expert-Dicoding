import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:flutter/foundation.dart';

class SeasonDetailNotifier extends ChangeNotifier {
  final TvRemoteDataSource remoteDataSource;

  SeasonDetailNotifier({required this.remoteDataSource});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  List<EpisodeModel> _episodes = [];
  List<EpisodeModel> get episodes => _episodes;

  Future<void> fetchSeasonDetail(int tvId, int seasonNumber) async {
    _state = RequestState.Loading;
    notifyListeners();
    try {
      final response =
          await remoteDataSource.getSeasonDetail(tvId, seasonNumber);
      _episodes = response.episodes;
      _state = RequestState.Loaded;
      notifyListeners();
    } catch (e) {
      _state = RequestState.Error;
      _message = e.toString();
      notifyListeners();
    }
  }
}
