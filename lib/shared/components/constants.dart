import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/login/login_screen.dart';
import '../network/local.dart';

TextButton SignOut(context) =>
    TextButton(
      onPressed: (){
        CacheHelper.removeData(key: 'token').then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen())
          );
        });
      },
      child: Text('SIGN OUT'),
    );

String token ='';

