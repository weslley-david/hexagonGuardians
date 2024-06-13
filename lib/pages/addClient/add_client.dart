import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();
  String code = '';
  String identifier = '';
  String feedbackMessage = '';
  bool isLoading = false;

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('acetoken');
  }

  Future<void> submitData() async {
    setState(() {
      isLoading = true;
    });

    final url =
        Uri.parse('https://hexagon-no2i.onrender.com/relation/specialist');

    String? token = await getAccessToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': code, 'identifier': identifier}),
    );

    if (response.statusCode == 200) {
      setState(() {
        feedbackMessage = 'Dados enviados com sucesso!';
      });
    } else {
      setState(() {
        feedbackMessage = 'Falha ao enviar dados: ${response.statusCode}';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Identifier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o identificador';
                  }
                  return null;
                },
                onSaved: (value) {
                  identifier = value!;
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o código';
                  }
                  return null;
                },
                onSaved: (value) {
                  code = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                submitData();
                              }
                            },
                            child: const Text('Enviar'),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(feedbackMessage),
            ],
          ),
        ),
      ),
    );
  }
}
