// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class NotificationModel {
//   final int? id;
//   final String? packageName;
//   final String? title;
//   final String? text;
//   final int timestamp;

//   NotificationModel({
//     this.id,
//     this.packageName,
//     this.title,
//     this.text,
//     required this.timestamp,
//   });

//   factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
//         id: json['id'],
//         packageName: json['package_name'],
//         title: json['title'],
//         text: json['text'],
//         timestamp: json['timestamp'],
//       );
// }

// class NotificationDatabase {
//   static final NotificationDatabase _instance = NotificationDatabase._internal();
//   factory NotificationDatabase() => _instance;
//   NotificationDatabase._internal();

//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     // init db
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, "notifications.db");

//     _database = await openDatabase(path, version: 1);
//     return _database!;
//   }

//   Future<List<NotificationModel>> getNotifications() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('notifications', orderBy: 'timestamp DESC');
//     return List.generate(maps.length, (i) {
//       return NotificationModel.fromMap(maps[i]);
//     });
//   }
// }
