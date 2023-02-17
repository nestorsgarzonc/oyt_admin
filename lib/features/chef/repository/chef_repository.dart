import 'package:oyt_admin/features/chef/datasource/chef_datasource.dart';
import 'package:oyt_admin/features/chef/models/chef_dto.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final chefRepositoryProvider = Provider<ChefRepository>(ChefRepositoryImpl.fromRef);

abstract class ChefRepository {
  Future<Either<Failure, List<Chef>>> getChefs();
  Future<Failure?> addChef(ChefDto chef);
}

class ChefRepositoryImpl implements ChefRepository {
  ChefRepositoryImpl(this.chefDataSource);

  factory ChefRepositoryImpl.fromRef(Ref ref) {
    final chefDataSource = ref.read(chefDatasourceProvider);
    return ChefRepositoryImpl(chefDataSource);
  }

  final ChefDataSource chefDataSource;

  @override
  Future<Either<Failure, List<Chef>>> getChefs() async {
    try {
      final res = await chefDataSource.getChefs();
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Failure?> addChef(ChefDto chef) async {
    try {
      await chefDataSource.addChef(chef);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
