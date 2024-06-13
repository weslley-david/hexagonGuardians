import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'https://hexagon-no2i.onrender.com/specialist/signin'), // substitua pela URL correta
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['signin'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('reftoken', data['reftoken']);
        await prefs.setString('acetoken', data['acetoken']);
        await prefs.setInt('id', data['id']);
        await prefs.setString('type', data['type']);
        await prefs.setString('identifier', data['identifier']);

        // Navegar para a HomePage
        // ignore: use_build_context_synchronously
        context.go('/home');
      } else {
        // Handle sign-in failure
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in failed')),
        );
      }
    } else {
      // Handle server error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data from server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('v0.1.0 (^~^)'),
      //   backgroundColor: Colors.blue,
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email: ',
                  filled: true,
                  //fillColor: Colors.white,
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10.0),
                  // ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password: ',
                  filled: true,
                  //fillColor: Colors.white,
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10.0),
                  // ),
                ),
                //decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator(
                      strokeCap: StrokeCap.square,
                      color: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          // Espaçamento entre os botões
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Por favor, entrar em contato com weslleydavid343@gmail.com')),
                                );
                              },
                              child: const Text(
                                'Cadastrar',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple[400],
                              ),
                              onPressed: () async {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                await login(email, password);
                              },
                              child: const Text(
                                'Login',
                              ),
                            ),
                          ),
                        ],
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
