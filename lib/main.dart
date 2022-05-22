import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/screens/on_boarding_screen.dart';
import 'package:shopping_app/shared/my_bloc_observer.dart';
import 'package:shopping_app/shared/network/remote.dart';
import 'package:shopping_app/shared/styles/colors.dart';

void main() {

  BlocOverrides.runZoned(
        () {
      // Use cubits...
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );

  DioHelper.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
          )
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Jannah'
      ),
      home:  OnBoardingScreen(),
    );
  }
}

