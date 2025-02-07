// // Mocks generated by Mockito 5.4.5 from annotations
// // in tv/test/presentation/pages/season_detail_page_test.dart.
// // Do not manually edit this file.
//
// // ignore_for_file: no_leading_underscores_for_library_prefixes
// import 'dart:async' as _i7;
// import 'dart:ui' as _i8;
//
// import 'package:core/utils/state_enum.dart' as _i4;
// import 'package:mockito/mockito.dart' as _i1;
// import 'package:mockito/src/dummies.dart' as _i5;
// import 'package:tv/data/datasources/tv_remote_data_source.dart' as _i2;
// import 'package:tv/data/models/episode_model.dart' as _i6;
// import 'package:tv/presentation/provider/season_detail_notifier.dart' as _i3;
//
// // ignore_for_file: type=lint
// // ignore_for_file: avoid_redundant_argument_values
// // ignore_for_file: avoid_setters_without_getters
// // ignore_for_file: comment_references
// // ignore_for_file: deprecated_member_use
// // ignore_for_file: deprecated_member_use_from_same_package
// // ignore_for_file: implementation_imports
// // ignore_for_file: invalid_use_of_visible_for_testing_member
// // ignore_for_file: must_be_immutable
// // ignore_for_file: prefer_const_constructors
// // ignore_for_file: unnecessary_parenthesis
// // ignore_for_file: camel_case_types
// // ignore_for_file: subtype_of_sealed_class
//
// class _FakeTvRemoteDataSource_0 extends _i1.SmartFake
//     implements _i2.TvRemoteDataSource {
//   _FakeTvRemoteDataSource_0(Object parent, Invocation parentInvocation)
//     : super(parent, parentInvocation);
// }
//
// /// A class which mocks [SeasonDetailNotifier].
// ///
// /// See the documentation for Mockito's code generation for more information.
// class MockSeasonDetailNotifier extends _i1.Mock
//     implements _i3.SeasonDetailNotifier {
//   MockSeasonDetailNotifier() {
//     _i1.throwOnMissingStub(this);
//   }
//
//   @override
//   _i2.TvRemoteDataSource get remoteDataSource =>
//       (super.noSuchMethod(
//             Invocation.getter(#remoteDataSource),
//             returnValue: _FakeTvRemoteDataSource_0(
//               this,
//               Invocation.getter(#remoteDataSource),
//             ),
//           )
//           as _i2.TvRemoteDataSource);
//
//   @override
//   _i4.RequestState get state =>
//       (super.noSuchMethod(
//             Invocation.getter(#state),
//             returnValue: _i4.RequestState.Empty,
//           )
//           as _i4.RequestState);
//
//   @override
//   String get message =>
//       (super.noSuchMethod(
//             Invocation.getter(#message),
//             returnValue: _i5.dummyValue<String>(
//               this,
//               Invocation.getter(#message),
//             ),
//           )
//           as String);
//
//   @override
//   List<_i6.EpisodeModel> get episodes =>
//       (super.noSuchMethod(
//             Invocation.getter(#episodes),
//             returnValue: <_i6.EpisodeModel>[],
//           )
//           as List<_i6.EpisodeModel>);
//
//   @override
//   bool get hasListeners =>
//       (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
//           as bool);
//
//   @override
//   _i7.Future<void> fetchSeasonDetail(int? tvId, int? seasonNumber) =>
//       (super.noSuchMethod(
//             Invocation.method(#fetchSeasonDetail, [tvId, seasonNumber]),
//             returnValue: _i7.Future<void>.value(),
//             returnValueForMissingStub: _i7.Future<void>.value(),
//           )
//           as _i7.Future<void>);
//
//   @override
//   void addListener(_i8.VoidCallback? listener) => super.noSuchMethod(
//     Invocation.method(#addListener, [listener]),
//     returnValueForMissingStub: null,
//   );
//
//   @override
//   void removeListener(_i8.VoidCallback? listener) => super.noSuchMethod(
//     Invocation.method(#removeListener, [listener]),
//     returnValueForMissingStub: null,
//   );
//
//   @override
//   void dispose() => super.noSuchMethod(
//     Invocation.method(#dispose, []),
//     returnValueForMissingStub: null,
//   );
//
//   @override
//   void notifyListeners() => super.noSuchMethod(
//     Invocation.method(#notifyListeners, []),
//     returnValueForMissingStub: null,
//   );
// }
