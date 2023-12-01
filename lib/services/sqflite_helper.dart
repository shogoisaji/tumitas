import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tumitas/models/bucket.dart';

class SqfliteHelper {
  static const _databaseName = "sqflite2_Database.db";
  static const _databaseVersion = 1;

  static const bucketTable = 'bucketTable';
  static const columnBucketId = 'BucketId';
  static const columnBucketTitle = 'bucketTitle';
  static const columnBucketDescription = 'bucketDescription';
  static const columnBucketInnerColor = 'bucketInnerColor';
  static const columnBucketOuterColor = 'bucketOuterColor';
  static const columnBucketLayoutSizeX = 'bucketLayoutSizeX';
  static const columnBucketLayoutSizeY = 'bucketLayoutSizeY';
  static const columnBucketIntoBlock = 'bucketIntoBlock';

  SqfliteHelper._();
  static final SqfliteHelper instance = SqfliteHelper._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $bucketTable (
            $columnBucketId INTEGER PRIMARY KEY,
            $columnBucketTitle TEXT NOT NULL,
            $columnBucketDescription TEXT,
            $columnBucketInnerColor INTEGER NOT NULL,
            $columnBucketOuterColor INTEGER NOT NULL,
            $columnBucketLayoutSizeX INTEGER NOT NULL,
            $columnBucketLayoutSizeY INTEGER NOT NULL,
            $columnBucketIntoBlock TEXT
          )
          ''');
  }

// add database row
  Future<int>? insertBucket(Bucket bucket) async {
    Database db = await instance.database;
    final row = {
      columnBucketTitle: bucket.bucketTitle,
      columnBucketDescription: bucket.bucketDescription,
      columnBucketInnerColor: bucket.bucketInnerColor.value,
      columnBucketOuterColor: bucket.bucketOuterColor.value,
      columnBucketLayoutSizeX: bucket.bucketLayoutSizeX,
      columnBucketLayoutSizeY: bucket.bucketLayoutSizeY,
      columnBucketIntoBlock: bucket.jsonEncodeBucketIntoBlock(),
    };
    final id = await db.insert(bucketTable, row);
    print('挿入された行のid: $id');
    print(
        '挿入されたデータ: ${row[columnBucketTitle]}, ${row[columnBucketDescription]}, ${row[columnBucketInnerColor]}, ${row[columnBucketOuterColor]}, ${row[columnBucketLayoutSizeX]}:${row[columnBucketLayoutSizeY]}, ${row[columnBucketIntoBlock]}');
    return id;
  }

// get database all rows
  Future<List<Bucket>> queryAllBucket() async {
    Database db = await instance.database;
    List<Map<String, dynamic>>? allBucket = await db.query(bucketTable);
    if (allBucket == []) return [];
    final List<Bucket> bucketList = allBucket.map((e) => mapToBucket(e)).toList();
    return bucketList;
  }

// find by Id
  Future<Bucket?> findBucketById(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      bucketTable,
      where: '$columnBucketId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return mapToBucket(maps.first);
    } else {
      return null;
    }
  }

  Bucket mapToBucket(Map<String, dynamic> map) {
    final Bucket bucket = Bucket(
      bucketTitle: map[columnBucketTitle],
      bucketDescription: map[columnBucketDescription] ?? '',
      bucketInnerColor: Color(map[columnBucketInnerColor]),
      bucketOuterColor: Color(map[columnBucketOuterColor]),
      bucketLayoutSizeX: map[columnBucketLayoutSizeX],
      bucketLayoutSizeY: map[columnBucketLayoutSizeY],
      bucketIntoBlock: Bucket.jsonDecodeBucketIntoBlock(json.decode(map[columnBucketIntoBlock])),
    );
    return bucket;
  }

// update bucketIntoBlock
  Future<int> updateBucketIntoBlock(int id, Bucket bucket) async {
    Database db = await instance.database;
    return await db.update(
      bucketTable,
      {
        columnBucketIntoBlock: bucket.jsonEncodeBucketIntoBlock(),
      },
      where: '$columnBucketId = ?',
      whereArgs: [id],
    );
  }

// delete row
  Future<int> deleteRow(int id) async {
    Database db = await instance.database;
    return await db.delete(
      bucketTable,
      where: '$columnBucketId = ?',
      whereArgs: [id],
    );
  }

// Total Records
  Future<String> getTotal() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT COUNT(*) as count FROM $bucketTable');

    return maps.first['count'].toString();
  }
}
