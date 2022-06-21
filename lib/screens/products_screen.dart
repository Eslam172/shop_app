import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/models/home_model.dart';
import 'package:shopping_app/shared/components/components.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/cubit/states.dart';
import 'package:shopping_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is AppSuccessFavoritesState){
          if(state.model.status == true){
            showToast(text: state.model.message, state: ToastState.SUCCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.homeModel != null,
            builder: (context) => productsBuilder(cubit.homeModel, context),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget productsBuilder(
    HomeModel? model,
    context,
  ) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CarouselSlider(
                items: model!.data.banners.map((e) {
                  return Image(
                    image: NetworkImage(e.image),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * .35,
                  initialPage: 0,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayInterval: const Duration(seconds: 3),
                  reverse: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  viewportFraction: 1.0,
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.grey[200],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.69,
                children: List.generate(
                    model.data.products.length,
                    (index) =>
                        buildProductItem(model.data.products[index], context)),
              ),
            )
          ],
        ),
      );

  Widget buildProductItem( model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage(model!.image),
                  height: 210,
                  width: double.infinity,
                ),
                model.discount != 0
                    ? Container(
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 1),
                        child: const Text(
                          'DISCOUNT',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    : Container(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, height: 1.3, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: primaryColor),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      model.discount != 0
                          ? Text(
                        model.old_price.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Container(),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context).changeFavorites(model.id);
                        },
                        icon:
                            AppCubit.get(context).favorites[model.id] ==
                                    true
                                ?  const Icon(
                                    Icons.favorite,
                                    color: primaryColor,
                                  )
                                :  const Icon(
                                    Icons.favorite_border,
                                  ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
