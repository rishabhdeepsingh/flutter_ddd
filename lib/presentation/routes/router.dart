import 'package:auto_route/auto_route.dart';
import 'package:flutter_ddd/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:flutter_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_ddd/presentation/splash/splash_page.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  MaterialRoute(page: SplashPage, initial: true),
  MaterialRoute(page: SignInPage),
  MaterialRoute(page: NotesOverviewPage),
])
class $Router {}
