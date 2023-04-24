import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'login_page.dart';

class Boasvindas extends StatefulWidget {
  const Boasvindas({super.key});

  @override
  State<Boasvindas> createState() => _BoasvindasState();
}

class _BoasvindasState extends State<Boasvindas> {
  void initState() {
    super.initState();
    // Verificar há o token no inicio da página
    // Se o valor for true, vai pra página Homepage
    verirfyToken().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Token responsável pela conexão com API
  //vamos verificar se há usuário ou não
  Future<bool> verirfyToken() async {
    //SharedPreferences vai verificar se temos token
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null) {
      return true;
    } else {
      return false;
    }
  }
}
