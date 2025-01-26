import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/season_detail_response.dart';
import 'package:ditonton/presentation/provider/season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'season_detail_notifier_test.mocks.dart';

@GenerateMocks([TvRemoteDataSource])
void main() {
  late SeasonDetailNotifier notifier;
  late MockTvRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTvRemoteDataSource();
    notifier = SeasonDetailNotifier(remoteDataSource: mockDataSource);
  });

  const tResponse = SeasonDetailResponse(
    id: 123,
    name: 'Season Name',
    episodes: [
      EpisodeModel(
        airDate: '2021-09-17',
        episodeNumber: 1,
        episodeType: 'standard',
        id: 999,
        name: 'Episode 1',
        overview: 'overview ep1',
        runtime: 60,
        seasonNumber: 1,
        showId: 123,
        stillPath: '/test.jpg',
        voteAverage: 8.0,
        voteCount: 100,
      )
    ],
  );

  test('should set state to Loaded and fill episodes when success', () async {
    when(mockDataSource.getSeasonDetail(123, 1))
        .thenAnswer((_) async => tResponse);
    await notifier.fetchSeasonDetail(123, 1);
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.episodes.length, 1);
  });

  test('should set state to Error when exception', () async {
    when(mockDataSource.getSeasonDetail(123, 1))
        .thenThrow(Exception('Some error'));
    await notifier.fetchSeasonDetail(123, 1);
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, contains('Some error'));
  });
}