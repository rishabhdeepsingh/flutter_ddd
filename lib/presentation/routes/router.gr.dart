// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../notes/notes_overview/notes_overview_page.dart' as _i4;
import '../sign_in/sign_in_page.dart' as _i3;
import '../splash/splash_page.dart' as _i2;

class Router extends _i1.RootStackRouter {
  Router();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: const _i2.SplashPage());
    },
    SignInPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: const _i3.SignInPage());
    },
    NotesOverviewPageRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i4.NotesOverviewPage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashPageRoute.name, path: '/'),
        _i1.RouteConfig(SignInPageRoute.name, path: '/sign-in-page'),
        _i1.RouteConfig(NotesOverviewPageRoute.name,
            path: '/notes-overview-page')
      ];
}

class SplashPageRoute extends _i1.PageRouteInfo {
  const SplashPageRoute() : super(name, path: '/');

  static const String name = 'SplashPageRoute';
}

class SignInPageRoute extends _i1.PageRouteInfo {
  const SignInPageRoute() : super(name, path: '/sign-in-page');

  static const String name = 'SignInPageRoute';
}

class NotesOverviewPageRoute extends _i1.PageRouteInfo {
  const NotesOverviewPageRoute() : super(name, path: '/notes-overview-page');

  static const String name = 'NotesOverviewPageRoute';
}
