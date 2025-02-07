// import 'package:core/utils/state_enum.dart';
// import 'package:tv/data/models/episode_model.dart';
// import 'package:tv/presentation/pages/season_detail_page.dart';
// import 'package:tv/presentation/provider/season_detail_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
//
// import 'season_detail_page_test.mocks.dart';
//
// @GenerateMocks([SeasonDetailNotifier])
// void main() {
//   late MockSeasonDetailNotifier mockNotifier;
//
//   Widget makeTestableWidget(Widget body) {
//     return ChangeNotifierProvider<SeasonDetailNotifier>.value(
//       value: mockNotifier,
//       child: MaterialApp(home: body),
//     );
//   }
//
//   setUp(() {
//     mockNotifier = MockSeasonDetailNotifier();
//   });
//
//   testWidgets('should display list of episodes', (WidgetTester tester) async {
//     // arrange
//     when(mockNotifier.state).thenReturn(RequestState.Loaded);
//     when(mockNotifier.episodes).thenReturn([
//       const EpisodeModel(
//         airDate: '2021-09-17',
//         episodeNumber: 1,
//         episodeType: 'standard',
//         id: 1922715,
//         name: 'Red Light, Green Light',
//         overview: 'Hoping to win easy money...',
//         runtime: 61,
//         seasonNumber: 1,
//         showId: 93405,
//         stillPath: '/vMFJS9LIUUAmQ1thq4.jpg',
//         voteAverage: 8.262,
//         voteCount: 879,
//       )
//     ]);
//     when(mockNotifier.message).thenReturn('');
//     await tester.pumpWidget(makeTestableWidget(
//       const SeasonDetailPage(tvId: 1, seasonNumber: 1),
//     ));
//     await tester.pump();
//
//     when(mockNotifier.state).thenReturn(RequestState.Loaded);
//     when(mockNotifier.episodes).thenReturn([
//       const EpisodeModel(airDate: '2021-09-17',
//         episodeNumber: 1,
//         episodeType: 'standard',
//         id: 1922715,
//         name: 'Red Light, Green Light',
//         overview: 'Hoping to win easy money...',
//         runtime: 61,
//         seasonNumber: 1,
//         showId: 93405,
//         stillPath: '/vMFJS9LIUUAmQ1thq4.jpg',
//         voteAverage: 8.262,
//         voteCount: 879,)
//     ]);
//   });
// }