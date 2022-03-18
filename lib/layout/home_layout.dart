import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../modules/archived_tasks/archived_tasks_screen.dart';
import '../modules/done_tasks/done_tasks_screen.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatelessWidget {
  
 
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

 

  @override
  Widget build(BuildContext context) {
    //var tasks = AppCubit.get(context).tasks;
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state) {
          if (state is AppInsertDataBasaState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
           body: state is AppGetDataBasaLoadingState
              ? Center(child: CircularProgressIndicator())
              : cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(title: titleController.text, date: dateController.text, time: timeController.text);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator: (vlaue) {
                                  if (vlaue!.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task Title',
                                  prefixIcon: Icon(Icons.title),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                controller: timeController,
                                //keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                validator: (vlaue) {
                                  if (vlaue!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task Time',
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                controller: dateController,
                                readOnly: true,
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-12-13'),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                validator: (vlaue) {
                                  if (vlaue!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task Date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20,
                    )
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                });
                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {

            cubit.changeIndex(index);

            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived'),
            ],
          ),
        );
        },
      ),
    );
  }
  }