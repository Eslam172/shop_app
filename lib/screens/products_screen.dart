import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/model/home_model.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/cubit/states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.homeModel!= null,
            builder: (context) => productsBuilder(cubit.homeModel,context),
            fallback: (context) => const Center(child: CircularProgressIndicator())
        );
      },
    );
  }

  Widget productsBuilder(HomeModel? model,context) => Column(
    children: [
      CarouselSlider(
          items: model!.data.banners.map((e)  {
            return Image(image: NetworkImage(e.image),
              width: double.infinity,
              fit: BoxFit.cover,
            );
          }).toList(),
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height*.35,
            initialPage: 0,

            scrollDirection: Axis.horizontal,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayInterval: const Duration(seconds: 3),
            reverse: false,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            viewportFraction: 1.0,
          )
      )
    ],
  );
}
