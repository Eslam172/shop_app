import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/model/home_model.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/cubit/states.dart';
import 'package:shopping_app/shared/styles/colors.dart';

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

  Widget productsBuilder(HomeModel? model,context,) => SingleChildScrollView(
    child: Column(
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
        ),
        const SizedBox(height: 20,),

        Container(
          color: Colors.grey[200],
          child: GridView.count(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1 / 1.6,
            children: List.generate(
                model.data.products.length,
                    (index) => buildProductItem(model.data.products[index],context)
            ),
          ),
        )
      ],
    ),
  );

  Widget buildProductItem(ProductModel? productModel,context) => Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image(image: NetworkImage(productModel!.image),
              height: 210,
            ),
            productModel.discount !=0 ?
            Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
              child: const Text('DISCOUNT',style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),),
            ):
            Container(),

          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(productModel.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                fontSize: 14,
                  height: 1.3,
                  fontWeight: FontWeight.w600
              ),),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Text(productModel.price.toString(),
                    style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor
                  ),),
                  const SizedBox(width: 5,),
                  productModel.discount !=0 ?
                  Text(productModel.old_price.toString(),
                    style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                      decoration: TextDecoration.lineThrough
                  ),) : Container(),
                  const Spacer(),
                  IconButton(
                      onPressed: (){
                        
                      },
                      icon: const Icon(Icons.favorite_border,
                      )
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
