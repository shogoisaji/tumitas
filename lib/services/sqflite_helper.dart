import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tumitas/models/bucket.dart';

class SqfliteHelper {
  static const _databaseName = "sqflite_Database.db";
  static const _databaseVersion = 1;

  static const bucketTable = 'bucket';
  static const columnBucketId = 'BucketId';
  static const columnBucketTitle = 'bucketTitle';
  static const columnBucketDescription = 'bucketDescription';
  static const columnBucketInnerColor = 'bucketInnerColor';
  static const columnBucketOuterColor = 'bucketOuterColor';
  static const columnBucketLayoutSize = 'bucketLayoutSize';
  static const columnBucketIntoBlock = 'bucketIntoBlock';

  SqfliteHelper._privateConstructor();
  static final SqfliteHelper instance = SqfliteHelper._privateConstructor();

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
            $columnBucketLayoutSize TEXT NOT NULL,
            $columnBucketIntoBlock TEXT
          )
          ''');
  }

  // Future<int> insert(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   return await db.insert(bucketTable, row);
  // }

// add database row
  Future<int>? insertBucket(Bucket bucket) async {
    Database db = await instance.database;
    final row = {
      columnBucketTitle: bucket.bucketTitle,
      columnBucketDescription: bucket.bucketDescription,
      columnBucketInnerColor: bucket.bucketInnerColor.value,
      columnBucketOuterColor: bucket.bucketOuterColor.value,
      columnBucketLayoutSize: bucket.bucketLayoutSize.toJson(),
      columnBucketIntoBlock: bucket.jsonEncodeBucketIntoBlock(),
    };
    final id = await db.insert(bucketTable, row);
    print('挿入された行のid: $id');
    print(
        '挿入されたデータ: ${row[columnBucketTitle]}, ${row[columnBucketDescription]}, ${row[columnBucketInnerColor]}, ${row[columnBucketOuterColor]}, ${row[columnBucketLayoutSize]}, ${row[columnBucketIntoBlock]}');
    return id;
  }

// get database all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(bucketTable);
  }

// find by Id
  Future<Map<String, dynamic>?> findById(int? id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      bucketTable,
      where: '$columnBucketId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

// update title
  Future<int> updateTitle(int id, String title) async {
    Database db = await instance.database;
    return await db.update(
      bucketTable,
      {columnBucketTitle: title},
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
