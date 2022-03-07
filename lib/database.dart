import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Plan {
  int? id;
  String title;
  String? text;
  String date;
  int isdone;

  Plan({
    this.id,
    required this.title,
    this.text,
    required this.date,
    required this.isdone,
  });

  Plan.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        text = json['text'],
        date = json['date'],
        isdone = json['isdone'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'date': date,
        'isdone': isdone,
      };
}

class PlanDatabase {
  PlanDatabase._privateConstructor();
  static final PlanDatabase instance = PlanDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'plans.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plans(
          id INTEGER PRIMARY KEY,
          title TEXT,
          text TEXT,
          date TEXT,
          isdone INTEGER
      )
      ''');
  }

  Future<List<Plan>> getPlans() async {
    Database db = await instance.database;
    var plans = await db.query('plans');
    List<Plan> planList =
        plans.isNotEmpty ? plans.map((c) => Plan.fromJson(c)).toList() : [];
    return planList;
  }

  Future<List<Plan>> getPlan(int id) async {
    Database db = await instance.database;
    var plans = await db.query('plans', where: 'id = ?', whereArgs: [id]);
    List<Plan> planList =
        plans.isNotEmpty ? plans.map((c) => Plan.fromJson(c)).toList() : [];
    return planList;
  }

  Future<int> add(Plan plan) async {
    Database db = await instance.database;
    return await db.insert('plans', plan.toJson());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('plans', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Plan plan) async {
    Database db = await instance.database;
    return await db
        .update('plans', plan.toJson(), where: "id = ?", whereArgs: [plan.id]);
  }
}

// const String tablePlan = 'plan';
// const String columnId = '_id';
// const String columnTitle = 'title';
// const String columnText = 'text';
// const String columnDate = 'date';
// const String columnIsDone = 'isdone';

// class PlanDatabase {
//   late Database db;

//   Future open(String path) async {
//     db = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute(
//           'CREATE TABLE $tablePlan ($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnText TEXT, $columnDate REAL, $columnIsDone REAL,)');
// //       await db.execute('''
// // create table $tablePlan (
// //   $columnId integer primary key autoincrement,
// //   $columnTitle text not null,
// //   $columnTitle text not null,
// //   $columnTitle text not null,
// //   $columnDone integer not null)
// // ''');
//     });
//   }

//   Future<Plan?> getPlans() async {
//     List<Map<String, dynamic>> maps = await db.query(tablePlan);
//     if (maps.isNotEmpty) {
//       return Plan.fromJson(maps.first);
//     }
//     return null;
//   }

//   Future<Plan?> getPlan(int id) async {
//     List<Map<String, dynamic>> maps = await db.query(tablePlan,
//         columns: [columnId, columnTitle, columnText, columnDate, columnIsDone],
//         where: '$columnId = ?',
//         whereArgs: [id]);
//     if (maps.isNotEmpty) {
//       return Plan.fromJson(maps.first);
//     }
//     return null;
//   }

//   Future<Plan> insert(Plan todo) async {
//     todo.id = await db.insert(tablePlan, todo.toJson());
//     return todo;
//   }

//   Future<int> delete(int id) async {
//     return await db.delete(tablePlan, where: '$columnId = ?', whereArgs: [id]);
//   }

//   Future<int> update(Plan todo) async {
//     return await db.update(tablePlan, todo.toJson(),
//         where: '$columnId = ?', whereArgs: [todo.id]);
//   }

//   Future close() async => db.close();
// }
