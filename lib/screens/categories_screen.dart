import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/model/categories_model.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/cubit/states.dart';
import 'package:shopping_app/shared/styles/colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
            condition: true,
            builder: (context) => ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => categoriesItem(cubit.categoriesModel!.data!.data![index]),
              itemCount: cubit.categoriesModel!.data!.data!.length,
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget categoriesItem(DataModel? model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 5,
                      blurStyle: BlurStyle.outer,
                      color: Colors.grey,
                      offset: Offset(5, 5),
                      spreadRadius: 5)
                ]),
            child: Row(
              children:  [
                Image(
                  image: NetworkImage('${model!.image}'),
                  fit: BoxFit.cover,
                  height: 100,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  '${model.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                ),
                const Spacer(),
                const CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            )),
      );
}
