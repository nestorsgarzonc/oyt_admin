import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oyt_admin/app.dart';
import 'package:oyt_admin/firebase_options.dart';
import 'package:oyt_front_core/push_notifications/push_notif_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = true;
  initializeDateFormatting('es_CO', null);
  await Firebase.initializeApp(
    options: Firebase.apps.isNotEmpty ? DefaultFirebaseOptions.currentPlatform : null,
  );
  await Hive.initFlutter();
  PushNotificationProvider.setupInteractedMessage();
  runApp(const ProviderScope(child: MyApp()));
}
