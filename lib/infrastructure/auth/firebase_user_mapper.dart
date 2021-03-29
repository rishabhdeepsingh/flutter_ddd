import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_ddd/domain/auth/user.dart';
import 'package:flutter_ddd/domain/core/value_objects.dart';

extension FirebaseUserDomainX on firebase.User {
  User toDomain() => User(id: UniqueId.fromUniqueString(uid));
}
