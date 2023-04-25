import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loginapp/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //FormKey é responsável em dizer se o usuário adicionou algum dado incorreto
  final _formkey = GlobalKey<FormState>();
  //os dados de email e senha, ou seja, vamos ter o controle
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formkey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: _emailController,
              //Tipo de teclado
              keyboardType: TextInputType.emailAddress,
              validator: (email) {
                //verificar se tudo que for dentro do email
                if (email == null || email.isEmpty) {
                  return 'Por favor, digite seu email';
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(_emailController.text)) {
                  return 'Por favor, digite um e-mail correto';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              controller: _passwordController,
              keyboardType: TextInputType.text,
              validator: (password) {
                if (password == null || password.isEmpty) {
                  return 'Por favor, digite sua senha';
                } else if (password.length < 6) {
                  return 'Digite uma senha maior que 6 caracteres';
                }
                return null;
              },
            ),
            //Botão que vai realizar ação
            ElevatedButton(
                onPressed: () async {
                  //verificar o formulário foi inserido sem erro
                  if (_formkey.currentState!.validate()) {
                    //fechando o teclado para página anterior
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    //chamando função de login
                    bool deuCerto = await login();
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (deuCerto) {
                      //navegando para página home
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      _passwordController.clear();
                      //Chamando SnapBar para exibir o erro
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: Text('Entrar'))
          ],
        ),
      ),
    ));
  }

//Exibir mensagem de erro
  final snackBar = const SnackBar(
    content: Text('E-mail ou senha inválidos', textAlign: TextAlign.center),
    backgroundColor: Colors.red,
  );

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('https://minhaapis.com.br/login/');
    var response = await http.post(url, body: {
      'username': _emailController.text,
      'password': _passwordController.text
    });
    if (response.statusCode == 200) {
      //retornando token
      print(jsonDecode(response.body)['token']);
      return true;
    } else {
      print(jsonDecode(response.body));
      return false;
    }
  }
}
