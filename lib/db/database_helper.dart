// import 'package:flutter/material.dart';
// import 'package:reader_tracker/models/book.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static const _databaseName = 'books_database.db';
//   static const _databaseVersion = 3;
//   static const _tableName = 'books';

//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   _initDatabase() async {
//     String path = await getDatabasesPath() + _databaseName;
//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE $_tableName (
//         id TEXT PRIMARY KEY,
//         title TEXT NOT NULL,
//         authors TEXT NOT NULL,
//         favorite INTEGER DEFAULT 0,
//         publisher TEXT,
//         publishedDate TEXT,
//         description TEXT,
//         industryIdentifiers TEXT,
//         pageCount INTEGER,
//         language TEXT,
//         imageLinks TEXT,
//         previewLink TEXT,
//         infoLink TEXT
//         )
//   ''');
//   }

//   Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < 3) {
//       // Add the 'favorite' column for existing DBs (no data loss)
//       await db.execute("ALTER TABLE $_tableName ADD COLUMN favorite INTEGER DEFAULT 0");
//     }
//     // future migrations: if (oldVersion < 3) { ... }
//   }

//   Future<int> insert(Book book) async {
//     Database db = await instance.database;
//     return await db.insert(_tableName, book.toJson());
//   }

//   Future<List <Book>> readAllBooks() async {
//     Database db = await instance.database;
//     var books = await db.query(_tableName);
//     return books.isNotEmpty 
//     ? books.map((bookData) 
//     => Book.fromJsonDatabase(bookData)).toList() : [];

//   }

//   Future<int> toggleFavoriteStatus(String id, bool isFavorite) async {
//     Database db = await instance.database;
//     int favoriteValue = isFavorite ? 1 : 0;
//     return await db.update(
//       _tableName,
//       {'favorite': favoriteValue},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }


import 'package:path/path.dart' as p;
import 'package:reader_tracker/models/book.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'books_database.db';
  static const _databaseVersion = 3; // keep bumped version
  static const _tableName = 'books';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);
    print('Opening DB at: $path (version=$_databaseVersion)');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // IMPORTANT: include onUpgrade so migrations run
      onOpen: (db) async {
        // safety net: ensure column exists even if migration didn't run for some reason
        final cols = await db.rawQuery('PRAGMA table_info($_tableName);');
        final names = cols.map((r) => r['name'].toString()).toList();
        if (!names.contains('favorite')) {
          print('onOpen: favorite column missing — adding now');
          await db.execute("ALTER TABLE $_tableName ADD COLUMN favorite INTEGER DEFAULT 0");
        } else {
          print('onOpen: favorite column present');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        authors TEXT NOT NULL,
        favorite INTEGER DEFAULT 0,
        publisher TEXT,
        publishedDate TEXT,
        description TEXT,
        industryIdentifiers TEXT,
        pageCount INTEGER,
        language TEXT,
        imageLinks TEXT,
        previewLink TEXT,
        infoLink TEXT
      )
    ''');
    print('DB created with table $_tableName');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('onUpgrade called: $oldVersion -> $newVersion');
    // If the DB was created at version 1 or 2, and we moved to 3, ensure favorite exists
    if (oldVersion < 2) {
      // If you previously introduced favorite in v2, add here for old v1 users
      try {
        await db.execute("ALTER TABLE $_tableName ADD COLUMN favorite INTEGER DEFAULT 0");
        print('Migration: added favorite column (oldVersion < 2)');
      } catch (e) {
        print('Migration error (oldVersion<2): $e');
      }
    }
    if (oldVersion < 3) {
      // In case you introduced/changed favorites logic in v3 as well (idempotent)
      try {
        // Add only if missing; ALTER TABLE ADD COLUMN will throw if column exists,
        // but we wrap in try/catch to avoid crash.
        await db.execute("ALTER TABLE $_tableName ADD COLUMN favorite INTEGER DEFAULT 0");
        print('Migration: added favorite column (oldVersion < 3)');
      } catch (e) {
        print('Migration note (oldVersion<3): $e');
      }
    }
    // add future migrations here
  }

  Future<int> insert(Book book) async {
    final Database db = await instance.database;
    return await db.insert(_tableName, book.toJson());
  }

  Future<List<Book>> readAllBooks() async {
    final Database db = await instance.database;
    final books = await db.query(_tableName);
    return books.isNotEmpty
        ? books.map((bookData) => Book.fromJsonDatabase(bookData)).toList()
        : [];
  }

  Future<int> toggleFavoriteStatus(String id, bool isFavorite) async {
    final Database db = await instance.database;
    final int favoriteValue = isFavorite ? 1 : 0;
    return await db.update(
      _tableName,
      {'favorite': favoriteValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
