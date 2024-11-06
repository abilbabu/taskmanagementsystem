
import 'package:sqflite/sqflite.dart';

class HomeScreenController  {
  static late Database myDatabase;
  static List<Map> NoteDataList = [];
  

  static Future initDb() async {

    myDatabase = await openDatabase("Note.Db", version: 1,
        onCreate: (Database db, int version) async {
   
      await db.execute(
          'CREATE TABLE Note (id INTEGER PRIMARY KEY, Title TEXT, Text TEXT,date TEXT)');
    });
  }

// add 
  static Future addNote({
    required String Title,
    required String Text,
  }) async {
     String currentDate = DateTime.now().toIso8601String();
    await myDatabase.rawInsert(
        'INSERT INTO Note (Title, Text) VALUES(?, ?)', [Title, Text]);
    getAllNote();
  }


// database display all data
  static Future getAllNote() async {
    NoteDataList = await myDatabase.rawQuery('SELECT * FROM Note');
  }

//remove the database
  static Future removeNote(int id) async {
    await myDatabase.rawDelete('DELETE FROM Note WHERE id = ?', [id]);
    getAllNote();
  }

//update the database
  static updateNote(
    String newTitle,
    String newText,
    int id,
  ) async {
    await myDatabase.rawUpdate(
        'UPDATE Note SET Title = ?, Text = ? WHERE id = ?',
        [newTitle, newText, id]);
    getAllNote();
  }
}
