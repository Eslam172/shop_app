import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/screens/login/login_screen.dart';
import 'package:shopping_app/screens/on_boarding_screen.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/my_bloc_observer.dart';
import 'package:shopping_app/shared/network/local.dart';
import 'package:shopping_app/shared/network/remote.dart';
import 'package:shopping_app/shared/styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

   token = CacheHelper.getData(key: 'token');
   print(token);

  late Widget widget;

  if (onBoarding != null) {
    if (token != null) {
      widget = const HomeScreen();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  //print(widget);
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(MyApp(
        onBoarding: onBoarding,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
   final onBoarding;
   final startWidget;

  MyApp({this.startWidget, this.onBoarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getHomeData()..getCategories()..getFavorites()..getUserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: primaryColor,
            primarySwatch: Colors.indigo,
            appBarTheme: const AppBarTheme(
                color: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: primaryColor),
                actionsIconTheme: IconThemeData(
                  color: primaryColor
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark)),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              elevation: 20,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white
            ),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Jannah',

        ),
        home: startWidget,
      ),
    );
  }
}
