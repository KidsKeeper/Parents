import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:convert';

import '../models/Parents.dart';
import '../models/ParentsKids.dart';
import '../models/KidsLocation.dart';
import '../Helper.dart';
import '../Server.dart';

class DB {
  DB._();

  static const _databaseName = 'kikeee_parents.db';

  static final DB instance = DB._();

  static Database _database;

  Future<Database> get database async {
    if( _database == null ) return await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(
      await getDatabasesPath(), _databaseName),
      version: 1,
      onCreate: ( Database db, int version ) async {
        await db.execute( "CREATE TABLE parents (id INTEGER PRIMARY KEY NOT NULL, parentsId INTEGER)" );
        await db.execute( "CREATE TABLE parentskids (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , kidsId INTEGER, name TEXT, key TEXT)" );
        await db.execute( "CREATE TABLE kidslocation (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , kidsId INTEGER, source TEXT, destination TEXT, polygon TEXT, start TEXT, end TEXT, date TEXT)" );
      }
    );
  }

  insertParentsId( String name, String key ) async {
    final Database db = await database;
    var parentsId = await _getParentsId(); // parentsId가 있는지 확인

    if( parentsId != -1 ) {
      _insertParentsKey( db, parentsId, name, key ); // 전에 parentsId 생성했더라면
    }

    else { // 처음으로 parentsId를 생성하는거라면
      parentsId = keyGenerate(); // 랜덤으로 키 생성
      parentsId = await parentsIdCompare(parentsId); // 서버에 있는 parentsId 값과 중복이 되는지 확인
      print(parentsId);

      Parents parents = Parents(
        id: 1,
        parentsId: parentsId,
      );

      await db.insert( 'parents', parents.toMap(), conflictAlgorithm: ConflictAlgorithm.replace );
      _insertParentsKey( db, parentsId, name, key );
    }
  }

  _insertParentsKey( db, parentsId, String name, String key ) async {
    try {
      var data = json.decode( await parentsKeyConfirm( parentsId, name, key ) );

      int kidsId = data["kidsId"];
      int result = data["result"];

      if( result == 1 ) { // 키 값이 맞다면
        ParentsKids parentsKids = ParentsKids(
          kidsId: kidsId,
          key: key,
          name: name
        );

        final List<Map<String, dynamic>> maps = await db.query('parentskids');
        int length = maps.length;

        for( var i = 0; i < length; i++ ) // to avoid duplication of parentskids
          if( data['kidsId'] == maps[i]['kidsId'] ) return;

        await db.insert( 'parentskids', parentsKids.toMap(), conflictAlgorithm: ConflictAlgorithm.replace );
      }

      else { print(result); } // 키 값이 맞지 않다면(0을 출력)
    }

    catch (e) { print(e); }
  }

  _getParentsId()  async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parents');
    int parentsId;

    try {
      parentsId = maps[0]['parentsId'];
    }

    catch (e) { parentsId = -1; print('no parentsId'); }

    return parentsId;
  }

  Future<List<KidsLocation>> getKidsLocation() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kidslocation');

//    try{
      return List.generate(maps.length, (i) {
        return KidsLocation(
            id: maps[i]['id'],
            start: maps[i]['start'],
            end: maps[i]['end'],
            polygon: maps[i]['polygon'],
            source: maps[i]['source'],
            destination: maps[i]['destination'],
            date: maps[i]['date']
        );
      });
//    }catch(e){
//      print(e);
//    }

  }

  Future<void> insertKidsLocation( Map<String, dynamic> data) async {
    final Database db = await database;

    try {
      List<dynamic> start = data['start'];
      List<dynamic> end = data['end'];
      List<dynamic> polygon = data['polygon'];

      String startString = start[0].toString() + ',' + start[1].toString();
      String endString = end[0].toString() + ',' + end[1].toString();

      String polygonString = '';

      for( int i = 0; i < polygon.length; i++ ) // sqlite의 한계로 array가 아닌 string으로 저장해야하므로 polygon안의 데이터들을 따로 뗴서 string으로 저장하는 과정.
        polygonString += polygon[i][0].toString() + "," + polygon[i][1].toString() + ",";

      polygonString = polygonString.substring( 0, polygonString.length - 1 ); // 맨 마지막 콤마(,)를 지우는 과정.

      KidsLocation kidsLocation = KidsLocation(
        kidsId: data['kidsId'],
        start: startString,
        end: endString,
        polygon: polygonString,
        date: data['date']
      );

      await db.insert( 'kidslocation', kidsLocation.toMap(), conflictAlgorithm: ConflictAlgorithm.replace );
    }

    catch (e) { print('1'); print(e); }
  }

  getParentsKidsName() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parentskids');

    List<String> nameList = List<String>.generate(maps.length, (i) => maps[i]['name'] ).toList();

    return nameList;
  }

  Future<int> getParentsKidsId( int index ) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parentskids');

    return maps[index]['kidsId'];
  }

  Future<List<Parents>> getParents() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query( 'parents', orderBy: 'id DESC' );

    return List.generate(maps.length, (i) {
      return Parents(
          id: maps[i]['id'],
          parentsId: maps[i]['parentsId'],
      );
    });
  }

  Future<List<ParentsKids>> getParentsKids() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query( 'parentskids', orderBy: 'id DESC' );

    return List.generate(maps.length, (i) {
      return ParentsKids(
          id: maps[i]['id'],
          kidsId: maps[i]['kidsId'],
          key: maps[i]['key'],
          name: maps[i]['name'],
      );
    });
  }

  deleteParentsId() async {
    final Database db = await database;
    db.delete( 'parents', where: 'id = ?', whereArgs: [1] );
  }

  deleteParentsKidsId( int id ) async {
    final Database db = await database;
    db.delete( 'parentskids', where: 'id = ?', whereArgs: [id] );
  }
}