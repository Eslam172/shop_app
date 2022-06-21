import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/shared/components/constants.dart';
import 'package:shopping_app/shared/cubit/cubit.dart';
import 'package:shopping_app/shared/cubit/states.dart';

class SettingsScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
     listener: (context , state) {},
     builder: (context , state) {
       var cubit = AppCubit.get(context);
       var model = AppCubit.get(context).userModel;

       nameController.text = model!.data!.name!;
       emailController.text = model.data!.email!;
       phoneController.text = model.data!.phone!;
       return ConditionalBuilder(
         condition: cubit.userModel!.data!= null,
         builder:(context) => Padding(
           padding: const EdgeInsets.all(20.0),
           child: Form(
             key: formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 if(state is AppLoadingUpdateUserState)
                   const LinearProgressIndicator(),
                 const SizedBox(height: 20,),
                 TextFormField(
                   controller:nameController ,
                   decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       label: Text('Name'),
                       prefixIcon: Icon(Icons.person)
                   ),
                   keyboardType: TextInputType.name,
                   validator: (String? value){
                     if(value!.isEmpty){
                       return 'Name must not be empty';
                     }
                   },
                 ),
                 const SizedBox(height: 20,),
                 TextFormField(
                   controller:emailController ,
                   decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       label: Text('Email Address'),
                       prefixIcon: Icon(Icons.email_outlined)
                   ),
                   keyboardType: TextInputType.emailAddress,
                   validator: (String? value){
                     if(value!.isEmpty){
                       return 'Email Address must not be empty';
                     }
                   },
                 ),
                 const SizedBox(height: 20,),
                 TextFormField(
                   controller:phoneController ,
                   decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       label: Text('Phone'),
                       prefixIcon: Icon(Icons.phone)
                   ),
                   keyboardType: TextInputType.emailAddress,
                   validator: (String? value){
                     if(value!.isEmpty){
                       return 'Phone must not be empty';
                     }
                   },
                 ),
                 const SizedBox(height: 20,),
                 ElevatedButton(
                   style: ButtonStyle(
                       padding: MaterialStateProperty.all(const EdgeInsets.only(top: 13,bottom: 13))
                   ),
                   onPressed: (){
                     if(formKey.currentState!.validate()){
                       cubit.updateUserModel(
                           name: nameController.text,
                           email: emailController.text,
                           phone: phoneController.text
                       );
                     }

                   },
                   child: const Text('UPDATE',style: TextStyle(
                       fontSize: 18
                   ),),
                 ),
                 const SizedBox(height: 20,),
                 ElevatedButton(
                   style: ButtonStyle(
                     padding: MaterialStateProperty.all(const EdgeInsets.only(top: 13,bottom: 13))
                   ),
                     onPressed: (){
                       SignOut(context);
                     },
                     child: const Text('LOGOUT',style: TextStyle(
                       fontSize: 18
                     ),),
                 ),
               ],
             ),
           ),
         ),
         fallback: (context) => const Center(child: CircularProgressIndicator()),
       );
     },
    );
  }
}
