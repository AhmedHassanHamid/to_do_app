import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../../widgets/componants.dart';

class NewTasksScreen extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: ((context, state) {}),
      builder: ((context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return tasks.length > 0 ? ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start:20),
            child: Container(
                  width: double.infinity,
                  height: 1,
                  color:Colors.grey[300],
                ),
          ),
          itemCount: tasks.length,) : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.menu,size: 100,color:Colors.grey,),
              Text('No tasks yet, please Add Some Tasks',style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold))
            ],),
          );
      }),
    );
  }
}
