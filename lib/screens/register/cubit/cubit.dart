import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/screens/login/cubit/states.dart';
import 'package:shopping_app/screens/register/cubit/states.dart';
import 'package:shopping_app/shared/end_points.dart';
import 'package:shopping_app/shared/network/remote.dart';

import '../../../models/login_model.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

   LoginModel? loginModel;
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,

  }) {
    emit(RegisterLoadingState());

    DioHelper.postData(url: REGISTER, data: {
      'name' : name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.data!.name);
      emit(RegisterSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState());
    });
  }

  Icon suffix = const Icon(Icons.visibility);
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix = isPassword
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off_outlined);

    emit(RegisterChangePasswordVisibilityState());
  }
}
