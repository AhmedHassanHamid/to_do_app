import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../widgets/componants.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: ((context, state) {}),
      builder: ((context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return  tasks.length > 0 ? ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start:20),
            child: Container(
                  width: double.infinity,
                  height: 1,
                  color:Colors.grey[300],
                ),
          ),
          itemCount: tasks.length,) :Center(
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