import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AvaliationDetailContent {
  final int number;
  final String content;
  final String answer;
  final String area;
  final String score;

  AvaliationDetailContent({
    required this.number,
    required this.content,
    required this.answer,
    required this.area,
    required this.score,
  });

  factory AvaliationDetailContent.fromJson(Map<String, dynamic> json) {
    return AvaliationDetailContent(
      number: json['number'],
      content: json['content'],
      answer: json['answer'],
      area: json['area'],
      score: json['score'],
    );
  }
}

Future<List<AvaliationDetailContent>> fetchAvaliationDetails(int id) async {
  final response = await http.get(Uri.parse(
      'https://hexagon-no2i.onrender.com/atec/answersbyavaliationid?id=$id'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body
        .map((dynamic item) => AvaliationDetailContent.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load avaliation details');
  }
}

class AvaliationDetail extends StatefulWidget {
  final int id;

  const AvaliationDetail({super.key, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _AvaliationDetailState createState() => _AvaliationDetailState();
}

class _AvaliationDetailState extends State<AvaliationDetail> {
  late Future<List<AvaliationDetailContent>> futureAvaliationDetails;

  @override
  void initState() {
    super.initState();
    futureAvaliationDetails = fetchAvaliationDetails(widget.id);
  }

  // Mapeamento de cores para cada área
  final Map<String, Color> areaColors = {
    "Fala/Linguagem/Comunicação": Colors.blue,
    "Percepção sensorial /cognitiva": Colors.green,
    "Saúde / Aspectos físicos / Comportamento": Colors.red,
    "Sociabilidade": Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Avaliação'),
      ),
      body: FutureBuilder<List<AvaliationDetailContent>>(
        future: futureAvaliationDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma pergunta encontrada'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                AvaliationDetailContent detail = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: areaColors[detail.area] ?? Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${detail.number} - ${detail.content}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Área: ${detail.area}',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: areaColors[detail.area] ?? Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Resposta: ${detail.answer}'),
                        Text('Pontuação: ${detail.score}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
