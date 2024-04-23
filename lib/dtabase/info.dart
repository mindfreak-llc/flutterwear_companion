// entity/person.dart

import 'dart:core';

import 'package:floor/floor.dart';

@entity
class Info {
  @primaryKey
  final String uuid;
  final int idsite;
  final String identifier;
  final String username;
  final String password;
  final String token;
  final String installations;
  Info(this.uuid,this.idsite,this.identifier,this.password,this.token,this.username,this.installations);
}