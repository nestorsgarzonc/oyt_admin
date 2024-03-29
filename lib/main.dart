import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oyt_admin/app.dart';
import 'package:oyt_admin/firebase_options.dart';
import 'package:oyt_front_core/logger/logger.dart';

void main() async {
  runZonedGuarded<Future>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      EquatableConfig.stringify = true;
      initializeDateFormatting('es_CO', null);
      if (kIsWeb) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      } else {
        await Firebase.initializeApp(
          options: Firebase.apps.isNotEmpty ? DefaultFirebaseOptions.currentPlatform : null,
        );
      }
      await Hive.initFlutter();
      FlutterError.onError = (FlutterErrorDetails details) {
        Logger.log(details.exceptionAsString());
        Logger.log(details.stack.toString());
      };
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stackTrace) {
      Logger.log(error.toString());
      Logger.log(stackTrace.toString());
    },
  );
}
