import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/bloc_observer.dart';

import 'layout/home_layout.dart';
import 'modules/counter/counter_screen.dart';

void main() async{
  
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}
  


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeLayout(),
    );
  }
}
