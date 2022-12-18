import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/auth/data_source/auth_datasource.dart';
import 'package:oyt_admin/features/auth/models/check_admin_response.dart';
import 'package:oyt_front_auth/data_source/auth_datasource.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_front_auth/repositories/auth_repositories.dart';

final authRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  return AdminAuthRepository.fromRead(ref);
});

class AdminAuthRepository extends AuthRepositoryImpl {
  AdminAuthRepository({required this.adminAuthDatasource, required super.authDatasource});

  factory AdminAuthRepository.fromRead(Ref ref) {
    final adminAuthDatasource = ref.read(adminAuthDatasourceProvider);
    final authDatasource = ref.read(authDatasourceProvider);
    return AdminAuthRepository(
      adminAuthDatasource: adminAuthDatasource,
      authDatasource: authDatasource,
    );
  }

  final AdminAuthDataSource adminAuthDatasource;

  Future<Either<Failure, CheckAdminResponse>> checkIfIsAdmin() async {
    try {
      final res = await adminAuthDatasource.checkIfIsAdmin();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
