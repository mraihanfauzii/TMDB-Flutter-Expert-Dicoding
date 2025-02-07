import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/data/models/season_detail_response.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_event.dart';
import 'package:tv/presentation/bloc/season_detail/season_detail_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'season_detail_bloc_test.mocks.dart';

@GenerateMocks([TvRemoteDataSource])
void main() {
  late SeasonDetailBloc bloc;
  late MockTvRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTvRemoteDataSource();
    bloc = SeasonDetailBloc(remoteDataSource: mockDataSource);
  });

  final tEpisode = EpisodeModel(
    airDate: '2023-01-01',
    episodeNumber: 1,
    episodeType: 'standard',
    id: 1,
    name: 'Episode 1',
    overview: 'Overview Episode 1',
    runtime: 60,
    seasonNumber: 1,
    showId: 1,
    stillPath: '/still.jpg',
    voteAverage: 8.0,
    voteCount: 50,
  );
  final tResponse = SeasonDetailResponse(
    id: 1,
    name: 'Season 1',
    episodes: [tEpisode],
  );

  group('FetchSeasonDetail', () {
    blocTest<SeasonDetailBloc, SeasonDetailState>(
      'emits [Loading, Loaded] when fetch is successful',
      build: () {
        when(mockDataSource.getSeasonDetail(1, 1))
            .thenAnswer((_) async => tResponse);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchSeasonDetail(1, 1)),
      expect: () => [
        const SeasonDetailState(state: RequestState.Loading),
        SeasonDetailState(state: RequestState.Loaded, episodes: tResponse.episodes),
      ],
    );

    blocTest<SeasonDetailBloc, SeasonDetailState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(mockDataSource.getSeasonDetail(1, 1))
            .thenThrow(Exception('Error fetching season detail'));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchSeasonDetail(1, 1)),
      expect: () => [
        const SeasonDetailState(state: RequestState.Loading),
        isA<SeasonDetailState>()
            .having((state) => state.state, 'state', RequestState.Error)
            .having((state) => state.message, 'message', contains('Error fetching season detail')),
      ],
    );
  });
}
