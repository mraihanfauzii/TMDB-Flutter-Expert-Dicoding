import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';

class GetTvDetail {
  final TvRepository repository;
  GetTvDetail(this.repository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
