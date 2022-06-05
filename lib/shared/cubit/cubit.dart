import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/model/categories_model.dart';
import 'package:shopping_app/model/home_model.dart';
import 'package:shopping_app/screens/categories_screen.dart';
import 'package:shopping_app/screens/favourites_screen.dart';
import 'package:shopping_app/screens/products_screen.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/cubit/states.dart';
import 'package:shopping_app/shared/end_points.dart';
import 'package:shopping_app/shared/network/remote.dart';

import '../../screens/settings_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex =0;

  List<Widget> bottomScreens =[
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    const SettingsScreen()
  ];

  void changeBottomIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

   HomeModel? homeModel;

  void getHomeData(){
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token
    ).then((value) {

      homeModel = HomeModel.fromJson(value.data);
      print(homeModel.toString());
      print(homeModel!.data.banners[0].image);

      emit(AppSuccessHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(AppErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories(){

    DioHelper.getData(url: GET_CATEGORIES,).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(AppSuccessCategoriesState());
    }).catchError((error){
      print(error.toString());
      emit(AppErrorCategoriesState());
    });
  }
}