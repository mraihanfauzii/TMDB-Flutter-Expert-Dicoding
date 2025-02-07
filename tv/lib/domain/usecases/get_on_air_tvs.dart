import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';

class GetOnAirTvs {
  final TvRepository repository;
  GetOnAirTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnAirTvs();
  }
}
