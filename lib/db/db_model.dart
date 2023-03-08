import 'package:flash_card/db/f_card_model.dart';
import 'package:flash_card/db/quiz_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseModel {
  Database? _database;

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    const dbname = 'flashcard.db';
    final path = join(dbPath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE flashcard(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        color INTEGER,
        charLength INTEGER,
        isFavorite INTEGER,
        creationDate TEXT
        )
    ''');
    await db.execute('''
    CREATE TABLE quiz(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryName TEXT,
        questionNo INTEGER
        )
    ''');
    await db.execute('''
    CREATE TABLE questions(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       questionId INTEGER,
       question TEXT,
       correctAns TEXT,
       wrongAns1 TEXT,
       wrongAns2 TEXT,
       wrongAns3 TEXT
       )
    ''');
  }

  Future<void> insertCard(FlashCard flashcard) async {
    final db = await database;
    await db.insert(
      'flashcard',
      flashcard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCard(FlashCard flashCard) async {
    final db = await database;
    await db.delete(
      'flashcard',
      where: 'id = ?',
      whereArgs: [flashCard.id],
    );
  }

  Future<FlashCard> readCard(int id) async {
    final db = await database;
    final maps = await db.query(
      'flashcard',
      columns: CardFields.values,
      where: '${CardFields.id} == ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FlashCard.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<FlashCard>> getCard() async {
    final db = await database;
    List<Map<String, dynamic>> items = await db.query(
      'flashcard',
      orderBy: 'creationDate DESC',
    );

    return List.generate(
      items.length,
      (index) => FlashCard(
        id: items[index]['id'],
        title: items[index]['title'],
        body: items[index]['body'],
        color: items[index]['color'],
        isFavorite: items[index]['isFavorite'] == 1 ? true : false,
        charLength: items[index]['charLength'],
        creationDate: DateTime.parse(items[index]['creationDate']),
      ),
    );
  }

  Future<int> updateCard(FlashCard flashCard) async {
    final db = await database;
    return db.update(
      'flashcard',
      flashCard.toJson(),
      where: '${CardFields.id} = ?',
      whereArgs: [flashCard.id],
    );
  }

  Future<List<FlashCard>> getFavCard() async {
    final db = await database;
    List<Map<String, dynamic>> items = await db.query(
      'flashcard',
      orderBy: 'id DESC',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return List.generate(
      items.length,
      (index) => FlashCard(
        id: items[index]['id'],
        title: items[index]['title'],
        body: items[index]['body'],
        color: items[index]['color'],
        isFavorite: items[index]['isFavorite'] == 1 ? true : false,
        charLength: items[index]['charLength'],
        creationDate: DateTime.parse(
          items[index]['creationDate'],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> queryQuiz(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryQuestions(
      String table, Model item) async {
    final db = await database;
    return db.query(
      table,
      where: 'questionId = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> insert(String table, Model item) async {
    final db = await database;
    return db.insert(table, item.toMap());
  }

  Future<int> delete(String table, Model item) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> update(String table, Model model) async {
    final db = await database;
    return db
        .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }
}
