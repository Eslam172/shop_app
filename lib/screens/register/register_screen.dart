import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/screens/login/cubit/cubit.dart';
import 'package:shopping_app/screens/login/cubit/states.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/screens/login/login_screen.dart';
import 'package:shopping_app/screens/register/cubit/cubit.dart';
import 'package:shopping_app/screens/register/cubit/states.dart';
import 'package:shopping_app/screens/register/register_screen.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/network/local.dart';

import '../../shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)  => RegisterCubit(),
      child: BlocConsumer<RegisterCubit , RegisterStates>(
        listener: (context , state) {
          if(state is RegisterSuccessState){
            if(state.loginModel.status == true){
              // print(state.loginModel.message);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context)=> const HomeScreen()),
                );
                showToast(
                    text: state.loginModel.message,
                    state: ToastState.SUCCESS
                );
              });
            }else{
              showToast(
                  text: state.loginModel.message,
                  state: ToastState.ERROR
              );
              // print(state.loginModel.message);
            }
          }
        },
        builder: (context , state) {

          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:  [
                      const Image(image: AssetImage('assets/images/login.png')),

                      TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          decoration:  const InputDecoration(
                            label:Text('Name') ,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),

                          )
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'Please enter  email address';
                            }
                            return null;
                          },
                          decoration:  const InputDecoration(
                            label:Text('Email Address') ,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),

                          )
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'Please enter  your password';
                            }
                            return null;
                          },
                          obscureText: cubit.isPassword,
                          decoration:  InputDecoration(
                              label:const Text('Password') ,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: InkWell(
                                child: cubit.suffix,
                                onTap: (){
                                  cubit.changePasswordVisibility();
                                },
                              )
                          )
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'Please enter your phone';
                            }
                            return null;
                          },
                          decoration:  const InputDecoration(
                            label:Text('Phone') ,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),

                          )
                      ),

                      const SizedBox(height: 15,),

                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(const EdgeInsets.all(10))
                            ),
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                cubit.userRegister(
                                  name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  phone: phoneController.text
                                );
                              }

                            },
                            child: const Text('REGISTER',style: TextStyle(
                                fontSize: 20
                            ),)
                        ),
                        fallback:(context) => const Center(child: CircularProgressIndicator()) ,
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account ?',style: TextStyle(
                              fontSize: 15
                          ),),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  LoginScreen())
                                );
                              },
                              child: const Text('LOGIN',style: TextStyle(
                                  fontSize: 16
                              ),)
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}