import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvNotifier notifier;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    notifier = WatchlistTvNotifier(getWatchlistTvs: mockGetWatchlistTvs);
  });

  final tTvList = <Tv>[
    const Tv(
      id: 123,
      name: 'Original Title',
      overview: 'Test overview',
      posterPath: '/poster.jpg',
      firstAirDate: '2021-09-17',
      voteAverage: 8.0,
    ),
  ];

  test('should change state to Loading then Loaded when fetch data success',
          () async {
        // arrange
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        // act
        await notifier.fetchWatchlistTvs();
        // assert
        expect(notifier.watchlistState, RequestState.Loaded);
        expect(notifier.watchlistTvs, tTvList);
      });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
    // act
    await notifier.fetchWatchlistTvs();
    // assert
    expect(notifier.watchlistState, RequestState.Error);
    expect(notifier.message, 'Server Error');
  });
}
