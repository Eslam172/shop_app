
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_app/screens/login/cubit/cubit.dart';
import 'package:shopping_app/screens/login/cubit/states.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/screens/register/register_screen.dart';
import 'package:shopping_app/shared/network/local.dart';

import '../../shared/components/components.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)  => LoginCubit(),
      child: BlocConsumer<LoginCubit , LoginStates>(
        listener: (context , state) {
          if(state is LoginSuccessState){
            if(state.loginModel.status){
             // print(state.loginModel.message);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context)=> HomeScreen()),
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

          var cubit = LoginCubit.get(context);
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

                      const SizedBox(height: 20,),

                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) => ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(const EdgeInsets.all(10))
                            ),
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }

                            },
                            child: const Text('LOGIN',style: TextStyle(
                                fontSize: 20
                            ),)
                        ),
                        fallback:(context) => const Center(child: CircularProgressIndicator()) ,
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account ?',style: TextStyle(
                              fontSize: 15
                          ),),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterScreen())
                                );
                              },
                              child: const Text('REGISTER',style: TextStyle(
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
