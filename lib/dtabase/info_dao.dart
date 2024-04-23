// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:flutterwear_companion/dtabase/info.dart';

@dao
abstract class InfoDao {
  @insert
  Future<void> insertinfo(Info info);
   @Query('SELECT * FROM Info')
  Future<List<Info>> findinfo();
  
}