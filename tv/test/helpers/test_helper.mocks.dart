// Mocks generated by Mockito 5.4.5 from annotations
// in tv/test/helpers/test_helper.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:convert' as _i20;
import 'dart:typed_data' as _i21;

import 'package:core/data/datasources/db/database_helper.dart' as _i17;
import 'package:core/utils/failure.dart' as _i8;
import 'package:dartz/dartz.dart' as _i2;
import 'package:http/http.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i16;
import 'package:movie/data/models/movie_table.dart' as _i19;
import 'package:sqflite/sqflite.dart' as _i18;
import 'package:tv/data/datasources/tv_local_data_source.dart' as _i14;
import 'package:tv/data/datasources/tv_remote_data_source.dart' as _i12;
import 'package:tv/data/models/season_detail_response.dart' as _i4;
import 'package:tv/data/models/tv_detail_model.dart' as _i3;
import 'package:tv/data/models/tv_model.dart' as _i13;
import 'package:tv/data/models/tv_table.dart' as _i15;
import 'package:tv/domain/entities/season.dart' as _i11;
import 'package:tv/domain/entities/tv.dart' as _i9;
import 'package:tv/domain/entities/tv_detail.dart' as _i10;
import 'package:tv/domain/repositories/tv_repository.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeTvDetailResponse_1 extends _i1.SmartFake
    implements _i3.TvDetailResponse {
  _FakeTvDetailResponse_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSeasonDetailResponse_2 extends _i1.SmartFake
    implements _i4.SeasonDetailResponse {
  _FakeSeasonDetailResponse_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeResponse_3 extends _i1.SmartFake implements _i5.Response {
  _FakeResponse_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeStreamedResponse_4 extends _i1.SmartFake
    implements _i5.StreamedResponse {
  _FakeStreamedResponse_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [TvRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvRepository extends _i1.Mock implements _i6.TvRepository {
  MockTvRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>> getOnAirTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getOnAirTvs, []),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i9.Tv>>(
                    this,
                    Invocation.method(#getOnAirTvs, []),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>> getPopularTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getPopularTvs, []),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i9.Tv>>(
                    this,
                    Invocation.method(#getPopularTvs, []),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>> getTopRatedTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getTopRatedTvs, []),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i9.Tv>>(
                    this,
                    Invocation.method(#getTopRatedTvs, []),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, _i10.TvDetail>> getTvDetail(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getTvDetail, [id]),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, _i10.TvDetail>>.value(
                  _FakeEither_0<_i8.Failure, _i10.TvDetail>(
                    this,
                    Invocation.method(#getTvDetail, [id]),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, _i10.TvDetail>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>> getTvRecommendations(
    int? id,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getTvRecommendations, [id]),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i9.Tv>>(
                    this,
                    Invocation.method(#getTvRecommendations, [id]),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>> searchTvs(String? query) =>
      (super.noSuchMethod(
            Invocation.method(#searchTvs, [query]),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i9.Tv>>(
                    this,
                    Invocation.method(#searchTvs, [query]),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, String>> saveWatchlistTv(
    _i10.TvDetail? tv,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#saveWatchlistTv, [tv]),
            returnValue: _i7.Future<_i2.Either<_i8.Failure, String>>.value(
              _FakeEither_0<_i8.Failure, String>(
                this,
                Invocation.method(#saveWatchlistTv, [tv]),
              ),
            ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, String>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, String>> removeWatchlistTv(
    _i10.TvDetail? tv,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#removeWatchlistTv, [tv]),
            returnValue: _i7.Future<_i2.Either<_i8.Failure, String>>.value(
              _FakeEither_0<_i8.Failure, String>(
                this,
                Invocation.method(#removeWatchlistTv, [tv]),
              ),
            ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, String>>);

  @override
  _i7.Future<bool> isAddedToWatchlistTv(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#isAddedToWatchlistTv, [id]),
            returnValue: _i7.Future<bool>.value(false),
          )
          as _i7.Future<bool>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>> getWatchlistTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getWatchlistTvs, []),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i9.Tv>>(
                    this,
                    Invocation.method(#getWatchlistTvs, []),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i9.Tv>>>);

  @override
  _i7.Future<_i2.Either<_i8.Failure, List<_i11.Season>>> getSeasonDetail() =>
      (super.noSuchMethod(
            Invocation.method(#getSeasonDetail, []),
            returnValue:
                _i7.Future<_i2.Either<_i8.Failure, List<_i11.Season>>>.value(
                  _FakeEither_0<_i8.Failure, List<_i11.Season>>(
                    this,
                    Invocation.method(#getSeasonDetail, []),
                  ),
                ),
          )
          as _i7.Future<_i2.Either<_i8.Failure, List<_i11.Season>>>);
}

/// A class which mocks [TvRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvRemoteDataSource extends _i1.Mock
    implements _i12.TvRemoteDataSource {
  MockTvRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<List<_i13.TvModel>> getOnAirTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getOnAirTvs, []),
            returnValue: _i7.Future<List<_i13.TvModel>>.value(<_i13.TvModel>[]),
          )
          as _i7.Future<List<_i13.TvModel>>);

  @override
  _i7.Future<List<_i13.TvModel>> getPopularTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getPopularTvs, []),
            returnValue: _i7.Future<List<_i13.TvModel>>.value(<_i13.TvModel>[]),
          )
          as _i7.Future<List<_i13.TvModel>>);

  @override
  _i7.Future<List<_i13.TvModel>> getTopRatedTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getTopRatedTvs, []),
            returnValue: _i7.Future<List<_i13.TvModel>>.value(<_i13.TvModel>[]),
          )
          as _i7.Future<List<_i13.TvModel>>);

  @override
  _i7.Future<_i3.TvDetailResponse> getTvDetail(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getTvDetail, [id]),
            returnValue: _i7.Future<_i3.TvDetailResponse>.value(
              _FakeTvDetailResponse_1(
                this,
                Invocation.method(#getTvDetail, [id]),
              ),
            ),
          )
          as _i7.Future<_i3.TvDetailResponse>);

  @override
  _i7.Future<List<_i13.TvModel>> getTvRecommendations(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getTvRecommendations, [id]),
            returnValue: _i7.Future<List<_i13.TvModel>>.value(<_i13.TvModel>[]),
          )
          as _i7.Future<List<_i13.TvModel>>);

  @override
  _i7.Future<List<_i13.TvModel>> searchTvs(String? query) =>
      (super.noSuchMethod(
            Invocation.method(#searchTvs, [query]),
            returnValue: _i7.Future<List<_i13.TvModel>>.value(<_i13.TvModel>[]),
          )
          as _i7.Future<List<_i13.TvModel>>);

  @override
  _i7.Future<_i4.SeasonDetailResponse> getSeasonDetail(
    int? tvId,
    int? seasonNumber,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getSeasonDetail, [tvId, seasonNumber]),
            returnValue: _i7.Future<_i4.SeasonDetailResponse>.value(
              _FakeSeasonDetailResponse_2(
                this,
                Invocation.method(#getSeasonDetail, [tvId, seasonNumber]),
              ),
            ),
          )
          as _i7.Future<_i4.SeasonDetailResponse>);
}

/// A class which mocks [TvLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvLocalDataSource extends _i1.Mock implements _i14.TvLocalDataSource {
  MockTvLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<String> insertWatchlistTv(_i15.TvTable? tv) =>
      (super.noSuchMethod(
            Invocation.method(#insertWatchlistTv, [tv]),
            returnValue: _i7.Future<String>.value(
              _i16.dummyValue<String>(
                this,
                Invocation.method(#insertWatchlistTv, [tv]),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  _i7.Future<String> removeWatchlistTv(_i15.TvTable? tv) =>
      (super.noSuchMethod(
            Invocation.method(#removeWatchlistTv, [tv]),
            returnValue: _i7.Future<String>.value(
              _i16.dummyValue<String>(
                this,
                Invocation.method(#removeWatchlistTv, [tv]),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  _i7.Future<_i15.TvTable?> getTvById(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getTvById, [id]),
            returnValue: _i7.Future<_i15.TvTable?>.value(),
          )
          as _i7.Future<_i15.TvTable?>);

  @override
  _i7.Future<List<_i15.TvTable>> getWatchlistTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getWatchlistTvs, []),
            returnValue: _i7.Future<List<_i15.TvTable>>.value(<_i15.TvTable>[]),
          )
          as _i7.Future<List<_i15.TvTable>>);
}

/// A class which mocks [DatabaseHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseHelper extends _i1.Mock implements _i17.DatabaseHelper {
  MockDatabaseHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i18.Database?> get database =>
      (super.noSuchMethod(
            Invocation.getter(#database),
            returnValue: _i7.Future<_i18.Database?>.value(),
          )
          as _i7.Future<_i18.Database?>);

  @override
  _i7.Future<int> insertWatchlist(_i19.MovieTable? movie) =>
      (super.noSuchMethod(
            Invocation.method(#insertWatchlist, [movie]),
            returnValue: _i7.Future<int>.value(0),
          )
          as _i7.Future<int>);

  @override
  _i7.Future<int> removeWatchlist(_i19.MovieTable? movie) =>
      (super.noSuchMethod(
            Invocation.method(#removeWatchlist, [movie]),
            returnValue: _i7.Future<int>.value(0),
          )
          as _i7.Future<int>);

  @override
  _i7.Future<Map<String, dynamic>?> getMovieById(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getMovieById, [id]),
            returnValue: _i7.Future<Map<String, dynamic>?>.value(),
          )
          as _i7.Future<Map<String, dynamic>?>);

  @override
  _i7.Future<List<Map<String, dynamic>>> getWatchlistMovies() =>
      (super.noSuchMethod(
            Invocation.method(#getWatchlistMovies, []),
            returnValue: _i7.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i7.Future<List<Map<String, dynamic>>>);

  @override
  _i7.Future<int> insertWatchlistTv(_i15.TvTable? tv) =>
      (super.noSuchMethod(
            Invocation.method(#insertWatchlistTv, [tv]),
            returnValue: _i7.Future<int>.value(0),
          )
          as _i7.Future<int>);

  @override
  _i7.Future<int> removeWatchlistTv(_i15.TvTable? tv) =>
      (super.noSuchMethod(
            Invocation.method(#removeWatchlistTv, [tv]),
            returnValue: _i7.Future<int>.value(0),
          )
          as _i7.Future<int>);

  @override
  _i7.Future<Map<String, dynamic>?> getTvById(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getTvById, [id]),
            returnValue: _i7.Future<Map<String, dynamic>?>.value(),
          )
          as _i7.Future<Map<String, dynamic>?>);

  @override
  _i7.Future<List<Map<String, dynamic>>> getWatchlistTvs() =>
      (super.noSuchMethod(
            Invocation.method(#getWatchlistTvs, []),
            returnValue: _i7.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i7.Future<List<Map<String, dynamic>>>);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClient extends _i1.Mock implements _i5.Client {
  MockHttpClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i5.Response> head(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#head, [url], {#headers: headers}),
            returnValue: _i7.Future<_i5.Response>.value(
              _FakeResponse_3(
                this,
                Invocation.method(#head, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<_i5.Response>);

  @override
  _i7.Future<_i5.Response> get(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#get, [url], {#headers: headers}),
            returnValue: _i7.Future<_i5.Response>.value(
              _FakeResponse_3(
                this,
                Invocation.method(#get, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<_i5.Response>);

  @override
  _i7.Future<_i5.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i20.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #post,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i5.Response>.value(
              _FakeResponse_3(
                this,
                Invocation.method(
                  #post,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i5.Response>);

  @override
  _i7.Future<_i5.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i20.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #put,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i5.Response>.value(
              _FakeResponse_3(
                this,
                Invocation.method(
                  #put,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i5.Response>);

  @override
  _i7.Future<_i5.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i20.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #patch,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i5.Response>.value(
              _FakeResponse_3(
                this,
                Invocation.method(
                  #patch,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i5.Response>);

  @override
  _i7.Future<_i5.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i20.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #delete,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
            returnValue: _i7.Future<_i5.Response>.value(
              _FakeResponse_3(
                this,
                Invocation.method(
                  #delete,
                  [url],
                  {#headers: headers, #body: body, #encoding: encoding},
                ),
              ),
            ),
          )
          as _i7.Future<_i5.Response>);

  @override
  _i7.Future<String> read(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
            Invocation.method(#read, [url], {#headers: headers}),
            returnValue: _i7.Future<String>.value(
              _i16.dummyValue<String>(
                this,
                Invocation.method(#read, [url], {#headers: headers}),
              ),
            ),
          )
          as _i7.Future<String>);

  @override
  _i7.Future<_i21.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#readBytes, [url], {#headers: headers}),
            returnValue: _i7.Future<_i21.Uint8List>.value(_i21.Uint8List(0)),
          )
          as _i7.Future<_i21.Uint8List>);

  @override
  _i7.Future<_i5.StreamedResponse> send(_i5.BaseRequest? request) =>
      (super.noSuchMethod(
            Invocation.method(#send, [request]),
            returnValue: _i7.Future<_i5.StreamedResponse>.value(
              _FakeStreamedResponse_4(
                this,
                Invocation.method(#send, [request]),
              ),
            ),
          )
          as _i7.Future<_i5.StreamedResponse>);

  @override
  void close() => super.noSuchMethod(
    Invocation.method(#close, []),
    returnValueForMissingStub: null,
  );
}
