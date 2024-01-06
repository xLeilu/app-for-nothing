import 'dart:io';

import 'package:appfornothing/models/book_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BookshelfHelper {
  BookshelfHelper._privateConstructor();
  static final BookshelfHelper instance = BookshelfHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'bookshelf.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookshelf(
        id INTEGER PRIMARY KEY,
        title TEXT,
        author TEXT,
        description TEXT
      )
    ''');
  }

  Future<List<BookModel>> getBooks() async {
    Database db = await instance.database;
    var books = await db.query('bookshelf', orderBy: 'id');
    List<BookModel> booksList =
        books.isNotEmpty ? books.map((e) => BookModel.fromMap(e)).toList() : [];
    return booksList;
  }

  Future<int> add(BookModel book) async {
    Database db = await instance.database;
    return await db.insert('bookshelf', book.toMap());
  }

  Future<int> removeBook(int bookId) async {
    Database db = await instance.database;
    return await db.delete('bookshelf', where: 'id = ?', whereArgs: [bookId]);
  }
}
