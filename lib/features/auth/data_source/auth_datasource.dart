import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/auth/models/check_admin_response.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/external/db_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';

final adminAuthDatasourceProvider = Provider<AdminAuthDataSource>((ref) {
  return AdminAuthDatasourceImpl.fromRead(ref);
});

abstract class AdminAuthDataSource {
  Future<CheckAdminResponse> checkIfIsAdmin();
}

class AdminAuthDatasourceImpl implements AdminAuthDataSource {
  factory AdminAuthDatasourceImpl.fromRead(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    final dbHandler = ref.read(dbHandlerProvider);
    return AdminAuthDatasourceImpl(apiHandler, dbHandler);
  }

  const AdminAuthDatasourceImpl(this.apiHandler, this.dbHandler);

  final ApiHandler apiHandler;
  final DBHandler dbHandler;

  @override
  Future<CheckAdminResponse> checkIfIsAdmin() async {
    try {
      final res = await apiHandler.get('/auth/is-admin');
      return CheckAdminResponse.fromMap(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
