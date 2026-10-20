import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';

class ArticleDatabase {
  static final ArticleDatabase instance = ArticleDatabase._init();

  static Database? _database;

  ArticleDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('clean_news.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_articles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        source TEXT,
        publishedAt TEXT,
        articleUrl TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // ==========================================================
  // SAVE ARTICLE
  // ==========================================================

  Future<void> saveArticle(Article article) async {
    final db = await database;

    await db.insert(
      'saved_articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==========================================================
  // GET ALL SAVED ARTICLES
  // ==========================================================

  Future<List<Article>> getSavedArticles() async {
    final db = await database;

    final result = await db.query('saved_articles', orderBy: 'id DESC');

    return result.map((map) {
      return Article.fromMap(map);
    }).toList();
  }

  // ==========================================================
  // CHECK IF ARTICLE IS SAVED
  // ==========================================================

  Future<bool> isSaved(String articleUrl) async {
    final db = await database;

    final result = await db.query(
      'saved_articles',
      where: 'articleUrl = ?',
      whereArgs: [articleUrl],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // ==========================================================
  // DELETE ARTICLE
  // ==========================================================

  Future<void> deleteArticle(String articleUrl) async {
    final db = await database;

    await db.delete(
      'saved_articles',
      where: 'articleUrl = ?',
      whereArgs: [articleUrl],
    );
  }

  // ==========================================================
  // DELETE ALL LOCAL ARTICLES
  // ==========================================================

  Future<void> deleteAllArticles() async {
    final db = await database;

    await db.delete('saved_articles');
  }

  // ==========================================================
  // CLOSE DATABASE
  // ==========================================================

  Future<void> close() async {
    final db = await database;

    await db.close();

    _database = null;
  }
}
