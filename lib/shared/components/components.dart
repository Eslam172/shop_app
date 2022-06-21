import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/models/home_model.dart';

import '../../models/favorites_model.dart';
import '../cubit/cubit.dart';
import '../styles/colors.dart';

Future<bool?> showToast({
  required String? text,
  required ToastState state,
}) => Fluttertoast.showToast(
    msg:text ,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastState{SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastState state){
  late Color color;
  switch(state){
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
      case ToastState.ERROR:
      color = Colors.red;
      break;
      case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct( model, context, {bool isOldPrice = true}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: SizedBox(
    height: 120,
    child: Row(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image(
              image: NetworkImage(model!.image),
              height: 120,
              width: 120,
            ),
            model.discount != 0 && isOldPrice
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
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w400),
              ),
              const Spacer(),
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
                  model.discount !=0 && isOldPrice
                      ? Text(
                    model.oldPrice.toString(),
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
                      AppCubit.get(context)
                          .changeFavorites(model.id);
                    },
                    icon: AppCubit.get(context)
                        .favorites[model.id] ==
                        true
                        ? const Icon(
                      Icons.favorite,
                      color: primaryColor,
                    )
                        : const Icon(
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
  ),
);

