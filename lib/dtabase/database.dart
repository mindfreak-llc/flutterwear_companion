// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutterwear_companion/dtabase/info.dart';
import 'package:flutterwear_companion/dtabase/info_dao.dart';
import 'package:flutterwear_companion/dtabase/info_dao.dart';

import 'package:sqflite/sqflite.dart' as sqflite;



part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Info])
abstract class AppDatabase extends FloorDatabase {

InfoDao get infoDao;
   
}