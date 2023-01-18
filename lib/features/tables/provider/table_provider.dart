import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/auth/provider/auth_provider.dart';
import 'package:oyt_admin/features/tables/provider/table_state.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_auth/models/connect_socket.dart';
import 'package:oyt_front_table/models/change_table_status.dart';
import 'package:oyt_front_table/models/customer_requests_response.dart';
import 'package:oyt_front_table/models/tables_socket_response.dart';
import 'package:oyt_front_table/models/users_table.dart';

final tableProvider = StateNotifierProvider<TableProvider, TableState>((ref) {
  return TableProvider.fromRead(ref);
});

class TableProvider extends StateNotifier<TableState> {
  TableProvider(this.socketIOHandler, {required this.ref}) : super(TableState.initial());

  factory TableProvider.fromRead(Ref ref) {
    final socketIo = ref.read(socketProvider);
    return TableProvider(socketIo, ref: ref);
  }

  final Ref ref;
  final SocketIOHandler socketIOHandler;

  void startListeningSocket() {
    listenTables();
    joinToRestaurant();
    listenCustomerRequests();
  }

  void listenCustomerRequests() {
    socketIOHandler.onMap(SocketConstants.customerRequests, (data) {
      final res = CustomerRequestsResponse.fromMap(data);
      state = state.copyWith(customerRequests: StateAsync.success(res));
    });
  }

  Future<void> listenTables() async {
    socketIOHandler.onMap(SocketConstants.listenTables, (data) {
      state = state.copyWith(
        tables: StateAsync.success(TablesSocketResponse.fromList(data['tables'])),
      );
    });
  }

  Future<void> joinToRestaurant() async {
    final restaurantId = ref.read(authProvider).restaurantId;
    socketIOHandler.emitMap(SocketConstants.joinToRestaurant, {
      'token': ref.read(authProvider).authModel.data?.bearerToken ?? '',
      'restaurantId': restaurantId,
    });
  }

  Future<void> changeStatus(TableStatus status, TableResponse table) async {
    socketIOHandler.emitMap(
      SocketConstants.changeTableStatus,
      ChangeTableStatus(
        tableId: table.id,
        token: ref.read(authProvider).authModel.data?.bearerToken ?? '',
        status: status,
      ).toMap(),
    );
  }

  void joinToTable(TableResponse table) {
    state = state.copyWith(tableUsers: StateAsync.loading());
    socketIOHandler.on(SocketConstants.listOfOrders, (data) {
      if ((data['table'] as Map).isEmpty) {
        state = state.copyWith(
          tableUsers: StateAsync.error(const Failure('No hay usuarios en la mesa')),
        );
        return;
      }
      final tableUsers = UsersTable.fromMap(data);
      Logger.log('################# START listenListOfOrders #################');
      Logger.log(tableUsers.toString());
      Logger.log('################# END listenListOfOrders #################');
      state = state.copyWith(tableUsers: StateAsync.success(tableUsers));
    });
    socketIOHandler.emitMap(SocketConstants.watchTable, {
      'token': ref.read(authProvider).authModel.data?.bearerToken ?? '',
      'tableId': table.id,
    });
  }

  Future<void> stopCallingWaiter(String tableId) async {
    socketIOHandler.emitMap(
      SocketConstants.stopCallWaiter,
      ConnectSocket(
        tableId: tableId,
        token: ref.read(authProvider).authModel.data?.bearerToken ?? '',
      ).toMap(),
    );
  }

  Future<void> callWaiter(String tableId) async {
    socketIOHandler.emitMap(
      SocketConstants.callWaiter,
      ConnectSocket(
        tableId: tableId,
        token: ref.read(authProvider).authModel.data?.bearerToken ?? '',
      ).toMap(),
    );
  }

  void leaveTable(TableResponse table) {
    state = state.copyWith(tableUsers: StateAsync.initial());
    socketIOHandler.emitMap(SocketConstants.leaveTable, {'tableId': table.id});
  }
}
