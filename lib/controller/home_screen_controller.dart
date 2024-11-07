import 'dart:developer';
import 'package:sqflite/sqflite.dart';

class HomeScreenController {
  static late Database myDatabase;
  static List<Map> NoteDataList = [];

  static Future initDb() async {
    myDatabase = await openDatabase("Notedb2.Db", version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Note12 (id INTEGER PRIMARY KEY, Title TEXT, Text TEXT, date TEXT)');
    });
  }

// add
  static Future addNote(
      {required String Title,
      required String Text,
      required String Datestring}) async {
    await myDatabase.rawInsert(
        'INSERT INTO Note12 (Title, Text, date) VALUES(?, ?, ?)',
        [Title, Text, Datestring]);
    getAllNote();
  }

// database display all data
  static Future getAllNote() async {
    String currentSelectedDate ;

    NoteDataList = await myDatabase
        .rawQuery('SELECT * FROM Note12 WHERE date =?', []);
    log(NoteDataList.toString());
  }

//remove the database
  static Future removeNote(int id) async {
    await myDatabase.rawDelete('DELETE FROM Note12 WHERE id = ?', [id]);
    getAllNote();
  }

//update the database
  static updateNote(
    String newTitle,
    String newText,
    int id,
  ) async {
    await myDatabase.rawUpdate(
        'UPDATE Note12 SET Title = ?, Text = ? WHERE id = ?',
        [newTitle, newText, id]);
    getAllNote();
  }
}
