import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/categories_model.dart';
import 'package:shopping_app/models/favorites_model.dart';
import 'package:shopping_app/models/home_model.dart';
import 'package:shopping_app/shared/components/components.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/styles/colors.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSuccessFavoritesState) {
          if (state.model.status == true) {
            showToast(text: state.model.message, state: ToastState.SUCCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
            condition: state is! AppLoadingGetFavoritesState,
            builder: (context) => cubit.favoritesModel!.data!.data!.isEmpty
                ? const Center(
                    child: Text(
                      'You don\'t have any favorites yet',
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildListProduct(
                        cubit.favoritesModel!.data!.data![index].product, context),
                    separatorBuilder: (context, index) => Container(
                      height: .4,
                      width: double.infinity,
                      color: primaryColor,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                    ),
                    itemCount: cubit.favoritesModel!.data!.data!.length,
                  ),
            fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }

}
