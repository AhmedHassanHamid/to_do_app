import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/modules/counter/cubit/states.dart';

import 'cubit/cubit.dart';

class CounterScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit,CounterStates>(
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
          appBar: AppBar(title: Text('Counter')),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){
                  CounterCubit.get(context).minus();
                },child:Text('MINUS'),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20),
                  child: Text('${CounterCubit.get(context).counter}',style: TextStyle(fontSize:50,fontWeight:FontWeight.w900),),
                ),
                TextButton(onPressed: (){
                  CounterCubit.get(context).plus();
                },child:Text('PLUS'),),
            ],),
          ),
        );
        },
      ),
    );
  }
}