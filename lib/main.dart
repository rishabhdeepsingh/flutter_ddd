import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddd/injection.dart';
import 'package:flutter_ddd/presentation/core/app_widget.dart';
import 'package:injectable/injectable.dart';

// ignore: avoid_void_async
void main() async {
  configureInjection(Environment.prod);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppWidget());
}
