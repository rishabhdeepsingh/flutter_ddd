part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  // we need to check if the user is signed in or not
  const factory AuthState.initial() = Initial;
  const factory AuthState.authenticated() = Authenticated;
  const factory AuthState.unauthenticated() = UnAuthenticated;
}
