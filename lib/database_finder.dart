// ignore_for_file: unused_import

import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:convert'; // For JSON encoding/decoding

import '../../feature/home/model/book_data.dart';

class DatabaseHelper {
  static const String _databaseName = "books.db";
  static const int _databaseVersion = 1;

  static const String table = "favorites";
  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnAuthors = "authors";
  static const String columnThumbnail = "thumbnail";
  static const String columnPrice = "price";
  static const String columnPublisher = "publisher";
  static const String columnDescription = "description";

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    var dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnThumbnail TEXT,
        $columnPrice REAL,
        $columnPublisher TEXT,
        $columnDescription TEXT
      )
    ''');
  }

  Future<int> addFavourite(BookDataModel book) async {
    final db = await database;
    try {
      final result = await db.insert(
        table,
        book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      debugPrint('Database insertion error: $e');
      return -1;
    }
  }

  Future<List<BookDataModel>> getFavouriteBooks() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(table);
      debugPrint('Fetched ${maps.length} favorite books');
      return maps.map((map) => BookDataModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Database query error: $e');
      return [];
    }
  }

  //  Get a single book by ID (to check if it's in favorites)
  Future<BookDataModel?> getBookById(String id) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        table,
        where: "$columnId = ?",
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return BookDataModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint('Database query error: $e');
      return null;
    }
  }

  //  Remove book from favorites
  Future<int> removeFavourite(String id) async {
    final db = await database;
    try {
      final result = await db.delete(
        table,
        where: "$columnId = ?",
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      debugPrint('Database deletion error: $e');
      return -1;
    }
  }
}
