import 'dart:io';
import 'dart:typed_data';
import 'package:appfornothing/models/book_model.dart';
import 'package:appfornothing/models/book_short_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:appfornothing/services/services.dart';

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
        category TEXT,
        description TEXT,
        photo BLOB
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

  Future<BookModel> getSingleBook(int bookId) async {
    Database db = await instance.database;

    //List<String> columnsToRetrieve = ['category', 'description'];

    var books =
        await db.query('bookshelf', where: 'id = ?', whereArgs: [bookId]);

    List<BookModel> booksList =
        books.isNotEmpty ? books.map((e) => BookModel.fromMap(e)).toList() : [];

    return booksList[0];
  }

  Future<List<BookShortModel>> getBooksWithoutBlob() async {
    Database db = await instance.database;

    List<String> columnsToRetrieve = [
      'id',
      'title',
      'author',
      'category',
      'description'
    ];

    var books =
        await db.query('bookshelf', columns: columnsToRetrieve, orderBy: 'id');
    List<BookShortModel> booksList = books.isNotEmpty
        ? books.map((e) => BookShortModel.fromMap(e)).toList()
        : [];
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

  Future<void> updatePhoto(int bookId, String photoPath) async {
    Database db = await instance.database;
    Uint8List imageBytes = await Services().getImageBytes(photoPath);
    await db.update(
      'bookshelf',
      {'photo': imageBytes},
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }
}
