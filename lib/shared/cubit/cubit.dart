import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

 static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
 int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done tasks',
    'Archived tasks',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

   late Database database;
   List<Map> newTasks = [];
   List<Map> doneTasks = [];
   List<Map> archivedTasks = [];
  void createDatabase()  {
     openDatabase(
      'todo.db1',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBasaState());
    });
  }

   insertToDatabase(
      {
      required String title,
      required String date,
      required String time}) async {
     await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('inserted successfully');
        emit(AppInsertDataBasaState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting ${error.toString()}');
      });
      return null;
    });
  }

  void updateData({
    required String status,
    required int id,
  })async {
     database.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    [status, id],).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataBasaState());
    });
  }

  void deleteData({
    required int id,
  })async {
     database.rawDelete(
    'DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBasaState());
    });
  }

  void getDataFromDatabase(database) {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDataBasaLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element) {
         if (element['status'] == 'new') {
           newTasks.add(element);
         }else if (element['status'] == 'done'){
           doneTasks.add(element);
         }else {
           archivedTasks.add(element);
         }
       });
         
          emit(AppGetDataBasaState());
        });
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
