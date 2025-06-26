import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDb {

  NotesDb._();

  static final NotesDb getInstance = NotesDb._() ;

  static final String Table_Note = "notes" ;
  static final String Column_SR_NO = "sr_no" ;
  static final String Column_Title = "title" ;
  static final String Column_Description = "description" ;

  Database? myDb ;

  Future<Database> getDB() async {

    myDb ??= await openDB() ;
    return myDb! ;

 /*   if(myDb!= null) {
      return myDb! ;
    }
    else {
      myDb = await openDB () ;
      return myDb! ;
    }*/

  } 
  

  Future<Database> openDB() async {

    Directory appDir = await getApplicationDocumentsDirectory() ;
   // String dbpath = join(appDir.path , "notes_db.dart") ;
   String dbpath = join(appDir.path , "noteDb.db") ;


    return await openDatabase(dbpath , 

    onCreate: (db, version) {

      db.execute("""

        CREATE TABLE $Table_Note(

        $Column_SR_NO INTEGER PRIMARY KEY AUTOINCREMENT ,
        $Column_Title TEXT NOT NULL ,
        $Column_Description TEXT NOT NULL 

        )
      """) ;


  } , version: 1) ;


}

Future<bool> addNotes(
 {required String title , required String description }
) async{

 // final db = await NotesDb.getInstance.getDB() ;

   var db = await getDB() ;  

  int rowsEffected = await db.insert( Table_Note, {
    Column_Title : title ,
    Column_Description : description ,
  
  }) ;
  
  return rowsEffected > 0 ;

}

 Future < List< Map < String,dynamic > > > readNotes() async {

 // final db = await NotesDb.getInstance.getDB() ;

    var db = await getDB() ; 

  List< Map < String,dynamic > > allNotes = await db.query( Table_Note );

  return allNotes ;


}

Future<bool> updateNotes(
  { required String title , required String description , required String sr_no}
) async{

  var db = await getDB() ; 

  int rowsEffected = await db.update( Table_Note, {
    Column_Title : title ,
    Column_Description : description ,
    
    
  } , where:  ' $Column_SR_NO = $sr_no ',
  ) ;
  
  return rowsEffected>0 ;

}

Future<bool> deleteNotes(int sr_no) async{

  final db = await NotesDb.getInstance.getDB() ;

  int rowsEffected = await db.delete( Table_Note , where: '$Column_SR_NO = ?' ,whereArgs: ["$sr_no"]) ;

  return rowsEffected>0 ;

}



}