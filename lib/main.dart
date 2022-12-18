import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oyt_admin/app.dart';


void main() async {
  EquatableConfig.stringify = true;
  initializeDateFormatting('es_CO', null);
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}
