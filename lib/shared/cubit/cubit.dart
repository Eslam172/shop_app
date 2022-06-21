import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/cahnge_favorites_model.dart';
import 'package:shopping_app/models/categories_model.dart';
import 'package:shopping_app/models/favorites_model.dart';
import 'package:shopping_app/models/home_model.dart';
import 'package:shopping_app/models/login_model.dart';
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
     SettingsScreen()
  ];

  void changeBottomIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

   HomeModel? homeModel;

  Map<int , bool> favorites ={};

  void getHomeData(){
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token
    ).then((value) {

      homeModel = HomeModel.fromJson(value.data);

      homeModel!.data.products.forEach((element) {
        favorites.addAll(
          {
            element.id : element.in_favorites
          }
        );
      });

     // print(favorites);

      emit(AppSuccessHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(AppErrorHomeDataState());
    });
  }
  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId){
    if(favorites[productId] == true) {
      favorites[productId] = false;
    }else{
      favorites[productId] = true;
    }
    emit(AppChangeFavoritesState());
    DioHelper.postData(url: FAVORITES,
        data: {
      'product_id' : productId,
        },
        token: token
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
    //  print(value.data);

      if(changeFavoritesModel!.status == false){
        if(favorites[productId] == true) {
          favorites[productId] = false;
        }else{
          favorites[productId] = true;
        }
      }else{
        getFavorites();
      }
      emit(AppSuccessFavoritesState(changeFavoritesModel!));
    }).catchError((error){
      print(error.toString());
      if(favorites[productId] == true) {
        favorites[productId] = false;
      }else{
        favorites[productId] = true;
      }
      emit(AppErrorFavoritesState());
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

  FavoritesModel? favoritesModel;

  void getFavorites(){

    emit(AppLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(AppSuccessGetFavoritesState(favoritesModel!));
    }).catchError((error){
      print(error.toString());
      emit(AppErrorGetFavoritesState());
    });
  }

  LoginModel? userModel;

  void getUserModel(){

    emit(AppLoadingUserState());
    DioHelper.getData(
        url: GET_USER,
        token: token
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(AppSuccessUserState());
    }).catchError((error){
      print(error.toString());
      emit(AppErrorUserState());
    });
  }

  void updateUserModel({
  required String name,
  required String email,
  required String phone,
}){

    emit(AppLoadingUpdateUserState());
    DioHelper.putData(
        url: UPDATE_USER,
        token: token,
      data: {
          'name' : name,
          'email' : email,
          'phone' : phone,
      }
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(AppSuccessUpdateUserState());
    }).catchError((error){
      print(error.toString());
      emit(AppErrorUpdateUserState());
    });
  }
}