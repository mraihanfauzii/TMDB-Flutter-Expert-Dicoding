import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Action');

  test('should convert from JSON', () {
    final json = {"id": 1, "name": "Action"};
    final result = GenreModel.fromJson(json);
    expect(result, tGenreModel);
  });

  test('should convert to JSON', () {
    final result = tGenreModel.toJson();
    expect(result["id"], 1);
    expect(result["name"], "Action");
  });

  test('should convert to entity', () {
    final entity = tGenreModel.toEntity();
    expect(entity, const Genre(id: 1, name: 'Action'));
  });
}