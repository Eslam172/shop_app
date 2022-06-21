import 'package:shopping_app/models/cahnge_favorites_model.dart';
import 'package:shopping_app/models/favorites_model.dart';

abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavState extends AppStates{}

class AppLoadingHomeDataState extends AppStates{}

class AppSuccessHomeDataState extends AppStates{}

class AppErrorHomeDataState extends AppStates{}

class AppSuccessCategoriesState extends AppStates{}

class AppErrorCategoriesState extends AppStates{}

class AppChangeFavoritesState extends AppStates{}

class AppSuccessFavoritesState extends AppStates{
  final ChangeFavoritesModel model;

  AppSuccessFavoritesState(this.model);

}

class AppErrorFavoritesState extends AppStates{}

class AppLoadingGetFavoritesState extends AppStates{}

class AppSuccessGetFavoritesState extends AppStates{
  final FavoritesModel model;

  AppSuccessGetFavoritesState(this.model);
}

class AppErrorGetFavoritesState extends AppStates{}

class AppLoadingUserState extends AppStates{}

class AppSuccessUserState extends AppStates{}

class AppErrorUserState extends AppStates{}

class AppLoadingUpdateUserState extends AppStates{}

class AppSuccessUpdateUserState extends AppStates{}

class AppErrorUpdateUserState extends AppStates{}