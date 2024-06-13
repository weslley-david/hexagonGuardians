import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import 'package:http/http.dart' as http; // Para enviar a requisição HTTP
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // Para converter os dados para JSON

class CreateClient extends StatefulWidget {
  const CreateClient({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateClientState createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  DateTime? _selectedDate;
  String _gender = 'feminino';

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('acetoken');
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String identifier = _identifierController.text;
      final String name = _nameController.text;
      final String bio = _bioController.text;
      final String birthdate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      final Map<String, dynamic> data = {
        'identifier': identifier,
        'name': name,
        'bio': bio,
        'birthdate': birthdate,
        'gender': _gender,
        'imageurl': 'https://hexagon-no2i.onrender.com/static/client.png'
      };

      String? token = await getAccessToken();

      final String jsonBody = json.encode(data);
      final response = await http.post(
        Uri.parse('https://hexagon-no2i.onrender.com/client'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Sucesso
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dados enviados com sucesso!')));
      } else {
        // Erro
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Identifier já cadastrado, tente um nome alternativo, se o problema persistir, contate o administrador')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _identifierController,
                decoration: const InputDecoration(labelText: 'Identifier'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um identifier';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma bio';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Birthdate'
                    : 'Birthdate: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Gênero'),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Masculino'),
                        value: 'masculino',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Feminino'),
                        value: 'feminino',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
