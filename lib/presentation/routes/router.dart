import 'package:auto_route/auto_route.dart';
import 'package:flutter_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_ddd/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
    generateNavigationHelperExtension: true,
    routes: <AutoRoute>[
      MaterialRoute(page: SplashPage, initial: true),
      MaterialRoute(page: SignInPage),
    ])
class $Router {}
