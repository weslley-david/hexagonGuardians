import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question {
  final int id;
  final String content;
  final String area;
  final List<Alternative> alternatives;

  Question({
    required this.id,
    required this.content,
    required this.area,
    required this.alternatives,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var alternativesFromJson = json['item_item_questionToquestion'] as List;
    List<Alternative> alternativesList = alternativesFromJson
        .map((altJson) => Alternative.fromJson(altJson))
        .toList();

    return Question(
      id: json['id'],
      content: json['content'],
      area: json['area'],
      alternatives: alternativesList,
    );
  }
}

class Alternative {
  final int id;
  final String content;
  final int score;

  Alternative({
    required this.id,
    required this.content,
    required this.score,
  });

  factory Alternative.fromJson(Map<String, dynamic> json) {
    return Alternative(
      id: json['id'],
      content: json['content'],
      score: int.parse(json['score']),
    );
  }
}

class Answer {
  final int questionId;
  final int alternativeId;

  Answer({
    required this.questionId,
    required this.alternativeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': questionId,
      'item': alternativeId,
    };
  }
}

class Atec extends StatefulWidget {
  final String client;
  const Atec({super.key, required this.client});

  @override
  State<Atec> createState() => _AtecState();
}

class _AtecState extends State<Atec> with TickerProviderStateMixin {
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('acetoken');
  }

  Future<String?> getIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('identifier');
  }

  final TextEditingController _titleController =
      TextEditingController(text: 'minha avaliação');
  final TextEditingController _observationController = TextEditingController();
  late final TabController _tabController;
  List<Question> questions = [];
  Map<int, int> selectedAlternatives = {};

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final Map<String, Color> areaColors = {
    "Fala/Linguagem/Comunicação": Colors.blue,
    "Percepção sensorial /cognitiva": Colors.green,
    "Saúde / Aspectos físicos / Comportamento": Colors.red,
    "Sociabilidade": Colors.orange,
  };

  void fetchQuestions() {
    // Simulação de fetch das questões de um endpoint
    String jsonData = '''[
  {
    "id": 1,
    "content": "Sabe próprio nome",
    "number": 1,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 413,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 1,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 414,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 1,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 415,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 1,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 2,
    "content": "Responde ao 'Não' ou 'Pare'",
    "number": 2,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 416,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 2,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 417,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 2,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 418,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 2,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 3,
    "content": "Pode obedecer certas ordens",
    "number": 3,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 419,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 3,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 420,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 3,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 421,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 3,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 4,
    "content": "Consegue usar uma palavra por vez",
    "number": 4,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 422,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 4,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 423,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 4,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 424,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 4,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 5,
    "content": "Consegue usar 2 palavras juntas",
    "number": 5,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 425,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 5,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 426,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 5,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 427,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 5,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 6,
    "content": "Consegue usar 3 palavras juntas",
    "number": 6,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 428,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 6,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 429,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 6,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 430,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 6,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 7,
    "content": "Sabe 10 ou mais palavras",
    "number": 7,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 431,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 7,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 432,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 7,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 433,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 7,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 8,
    "content": "Consegue usar orações com 4 ou mais palavras",
    "number": 8,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 434,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 8,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 435,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 8,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 436,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 8,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 9,
    "content": "Explica o que quer",
    "number": 9,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 437,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 9,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 438,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 9,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 439,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 9,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 10,
    "content": "Faz perguntas com sentido",
    "number": 10,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 440,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 10,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 441,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 10,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 442,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 10,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 11,
    "content": "Sua linguagem costuma ser relevante/com sentido",
    "number": 11,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 443,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 11,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 444,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 11,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 445,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 11,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 15,
    "content": "Parece estar fechado em si mesmo - não é possível interagir com ele/ela",
    "number": 15,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 455,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 15,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 456,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 15,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 457,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 15,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 16,
    "content": "Não presta atenção nas pessoas",
    "number": 16,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 458,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 16,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 459,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 16,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 460,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 16,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 17,
    "content": "Mostra pouca ou nada de atenção quando falamos com ele",
    "number": 17,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 461,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 17,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 462,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 17,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 463,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 17,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 18,
    "content": "Não é cooperativo e é resistente",
    "number": 18,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 464,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 18,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 465,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 18,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 466,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 18,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 19,
    "content": "Não tem contato ocular",
    "number": 19,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 467,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 19,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 468,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 19,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 469,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 19,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 20,
    "content": "Prefere que o deixem sozinho",
    "number": 20,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 470,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 20,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 471,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 20,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 472,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 20,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 21,
    "content": "Não demonstra afeto",
    "number": 21,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 473,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 21,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 474,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 21,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 475,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 21,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 22,
    "content": "Não cumprimenta os pais",
    "number": 22,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 476,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 22,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 477,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 22,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 478,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 22,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 23,
    "content": "Evita contato com outras pessoas",
    "number": 23,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 479,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 23,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 480,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 23,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 481,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 23,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 24,
    "content": "Não imita",
    "number": 24,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 482,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 24,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 483,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 24,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 484,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 24,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 25,
    "content": "Não gosta que lhe abracem ou acariciem",
    "number": 25,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 485,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 25,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 486,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 25,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 487,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 25,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 35,
    "content": "Responde ao próprio nome",
    "number": 35,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 515,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 35,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 516,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 35,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 517,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 35,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 36,
    "content": "Reconhece quando é elogiado",
    "number": 36,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 518,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 36,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 519,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 36,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 520,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 36,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 37,
    "content": "Olha para as pessoas e animais",
    "number": 37,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 521,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 37,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 522,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 37,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 523,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 37,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 38,
    "content": "Assiste desenhos na TV",
    "number": 38,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 524,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 38,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 525,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 38,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 526,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 38,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 39,
    "content": "Desenha, colore, faz objetos de arte",
    "number": 39,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 527,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 39,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 528,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 39,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 529,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 39,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 40,
    "content": "Brinca com os brinquedos de forma correta",
    "number": 40,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 530,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 40,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 531,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 40,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 532,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 40,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 41,
    "content": "Tem uma expressão facial apropriada",
    "number": 41,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 533,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 41,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 534,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 41,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 535,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 41,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 42,
    "content": "Entende as histórias da TV",
    "number": 42,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 536,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 42,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 537,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 42,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 538,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 42,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 43,
    "content": "Entende as suas explicações",
    "number": 43,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 539,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 43,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 540,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 43,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 541,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 43,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 44,
    "content": "Está consciente do ambiente que lhe rodeia",
    "number": 44,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 542,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 44,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 543,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 44,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 544,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 44,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 45,
    "content": "Tem consciência de perigo",
    "number": 45,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 545,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 45,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 546,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 45,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 547,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 45,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 46,
    "content": "Mostra imaginação",
    "number": 46,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 548,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 46,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 549,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 46,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 550,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 46,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 47,
    "content": "Inicia atividades",
    "number": 47,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 551,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 47,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 552,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 47,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 553,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 47,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 48,
    "content": "Se veste sozinho",
    "number": 48,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 554,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 48,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 555,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 48,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 556,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 48,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 53,
    "content": "Enuresis (urina na cama)",
    "number": 53,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 569,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 53,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 570,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 53,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 571,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 53,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 572,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 53,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 54,
    "content": "Urina nas calças ou fralda",
    "number": 54,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 573,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 54,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 574,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 54,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 575,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 54,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 576,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 54,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 55,
    "content": "Defeca nas calças ou fralda",
    "number": 55,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 577,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 55,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 578,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 55,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 579,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 55,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 580,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 55,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 56,
    "content": "Diarreia",
    "number": 56,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 581,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 56,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 582,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 56,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 583,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 56,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 584,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 56,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 57,
    "content": "Prisão de ventre",
    "number": 57,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 585,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 57,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 586,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 57,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 587,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 57,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 588,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 57,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 58,
    "content": "Problemas para dormir",
    "number": 58,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 589,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 58,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 590,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 58,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 591,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 58,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 592,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 58,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 59,
    "content": "Come muito/muito pouco",
    "number": 59,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 593,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 59,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 594,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 59,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 595,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 59,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 596,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 59,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 60,
    "content": "Dieta extremamente limitada, não aceita qualquer comida",
    "number": 60,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 597,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 60,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 598,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 60,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 599,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 60,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 600,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 60,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 61,
    "content": "Hiperativo",
    "number": 61,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 601,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 61,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 602,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 61,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 603,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 61,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 604,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 61,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 62,
    "content": "Letárgico",
    "number": 62,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 605,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 62,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 606,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 62,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 607,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 62,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 608,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 62,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 63,
    "content": "Machuca a si mesmo",
    "number": 63,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 609,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 63,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 610,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 63,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 611,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 63,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 612,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 63,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 64,
    "content": "Machuca os outros",
    "number": 64,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 613,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 64,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 614,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 64,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 615,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 64,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 616,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 64,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 12,
    "content": "Com frequência usa várias orações sucessivas",
    "number": 12,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 446,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 12,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 447,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 12,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 448,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 12,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 13,
    "content": "Mantém uma conversa razoavelmente boa",
    "number": 13,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 449,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 13,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 450,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 13,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 451,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 13,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 26,
    "content": "Não compartilha/mostra coisas aos outros",
    "number": 26,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 488,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 26,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 489,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 26,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 490,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 26,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 27,
    "content": "Não se despede fazendo tchau",
    "number": 27,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 491,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 27,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 492,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 27,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 493,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 27,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 28,
    "content": "Desagradável/desobediente",
    "number": 28,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 494,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 28,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 495,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 28,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 496,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 28,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 29,
    "content": "Birras",
    "number": 29,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 497,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 29,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 498,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 29,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 499,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 29,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 30,
    "content": "Não tem amigos/companheiros",
    "number": 30,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 500,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 30,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 501,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 30,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 502,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 30,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 31,
    "content": "Sorri muito pouco",
    "number": 31,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 503,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 31,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 504,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 31,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 505,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 31,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 32,
    "content": "Insensível aos sentimentos dos outros",
    "number": 32,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 506,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 32,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 507,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 32,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 508,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 32,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 33,
    "content": "Não tem interesse em agradar os outros",
    "number": 33,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 509,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 33,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 510,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 33,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 511,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 33,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 34,
    "content": "Fica indiferente quando os pais vão embora, se distanciam",
    "number": 34,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Sociabilidade",
    "item_item_questionToquestion": [
      {
        "id": 512,
        "content": "Não descritivo",
        "number": 2,
        "score": "0",
        "question": 34,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 513,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 34,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 514,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 34,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 14,
    "content": "Tem capacidade normal de comunicação para a sua idade",
    "number": 14,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Fala/Linguagem/Comunicação",
    "item_item_questionToquestion": [
      {
        "id": 452,
        "content": "Não verdadeiro",
        "number": 2,
        "score": "0",
        "question": 14,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 453,
        "content": "Mais ou menos",
        "number": 1,
        "score": "1",
        "question": 14,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 454,
        "content": "Verdade",
        "number": 0,
        "score": "2",
        "question": 14,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 49,
    "content": "Curioso, interessado",
    "number": 49,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 557,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 49,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 558,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 49,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 559,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 49,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 50,
    "content": "Se aventura, explora",
    "number": 50,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 560,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 50,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 561,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 50,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 562,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 50,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 51,
    "content": "Sintonizado, não parece estar 'nas nuvens'",
    "number": 51,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 563,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 51,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 564,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 51,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 565,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 51,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 52,
    "content": "Olha para onde os outros olham",
    "number": 52,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Percepção sensorial /cognitiva",
    "item_item_questionToquestion": [
      {
        "id": 566,
        "content": "Não descreve meu filho",
        "number": 2,
        "score": "0",
        "question": 52,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 567,
        "content": "Descreve um pouco",
        "number": 1,
        "score": "1",
        "question": 52,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 568,
        "content": "Descreve o meu filho",
        "number": 0,
        "score": "2",
        "question": 52,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 65,
    "content": "Destrutivo",
    "number": 65,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 617,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 65,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 618,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 65,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 619,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 65,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 620,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 65,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 66,
    "content": "Sensível a barulho",
    "number": 66,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 621,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 66,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 622,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 66,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 623,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 66,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 624,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 66,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 67,
    "content": "Ansioso/medroso",
    "number": 67,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 625,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 67,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 626,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 67,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 627,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 67,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 628,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 67,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 68,
    "content": "Triste/chora",
    "number": 68,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 629,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 68,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 630,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 68,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 631,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 68,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 632,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 68,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 69,
    "content": "Convulsões",
    "number": 69,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 633,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 69,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 634,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 69,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 635,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 69,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 636,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 69,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 70,
    "content": "Fala/linguagem obsessiva",
    "number": 70,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 637,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 70,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 638,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 70,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 639,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 70,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 640,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 70,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 71,
    "content": "Rotinas rígidas",
    "number": 71,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 641,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 71,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 642,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 71,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 643,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 71,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 644,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 71,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 72,
    "content": "Grita",
    "number": 72,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 645,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 72,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 646,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 72,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 647,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 72,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 648,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 72,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 73,
    "content": "Exige que as coisas sejam sempre feitas da mesma forma",
    "number": 73,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 649,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 73,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 650,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 73,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 651,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 73,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 652,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 73,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 74,
    "content": "Com frequência fica agitado",
    "number": 74,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 653,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 74,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 654,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 74,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 655,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 74,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 656,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 74,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 75,
    "content": "Não é sensível a dor",
    "number": 75,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 657,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 75,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 658,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 75,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 659,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 75,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 660,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 75,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 76,
    "content": "Obcecado com certos objetos/temas",
    "number": 76,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 661,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 76,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 662,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 76,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 663,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 76,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 664,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 76,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  },
  {
    "id": 77,
    "content": "Faz gestos, movimentos repetitivos",
    "number": 77,
    "test": 1,
    "created_at": "2024-04-09T16:23:50.848Z",
    "updated_at": "2024-04-09T16:23:50.848Z",
    "area": "Saúde / Aspectos físicos / Comportamento",
    "item_item_questionToquestion": [
      {
        "id": 665,
        "content": "Não é um problema",
        "number": 2,
        "score": "0",
        "question": 77,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 666,
        "content": "Problema menor",
        "number": 1,
        "score": "1",
        "question": 77,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 667,
        "content": "Problema moderado",
        "number": 0,
        "score": "2",
        "question": 77,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      },
      {
        "id": 668,
        "content": "Problema sério",
        "number": 0,
        "score": "3",
        "question": 77,
        "created_at": "2024-04-10T13:41:28.071Z",
        "updated_at": "2024-04-10T13:41:28.071Z"
      }
    ]
  }
]''';

    List<dynamic> jsonResult = json.decode(jsonData);
    List<Question> fetchedQuestions =
        jsonResult.map((json) => Question.fromJson(json)).toList();

    setState(() {
      questions = fetchedQuestions;
    });
  }

  Future<void> submitAnswers() async {
    List<Answer> answers = selectedAlternatives.entries.map((entry) {
      return Answer(
        questionId: entry.key,
        alternativeId: entry.value,
      );
    }).toList();

    String? identifier = await getIdentifier();

    Map<String, dynamic> submission = {
      "title": '${_titleController.text} - por $identifier',
      "notes": _observationController.text,
      "client": int.parse(widget.client),
      "answers": answers.map((answer) => answer.toJson()).toList(),
    };

    if (answers.length != 77) {
      //String jsonSubmission = json.encode(submission);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as questões precisam ser respondidas.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    String? token = await getAccessToken();

    final response = await http.post(
      Uri.parse('https://hexagon-no2i.onrender.com/atec/submit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(submission),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enviado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
      // ignore: use_build_context_synchronously
      context.pop();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao enviar os dados'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATEC'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.checklist_rtl),
            ),
            Tab(
              icon: Icon(Icons.notes_outlined),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          questions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    Question question = questions[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: areaColors[question.area] ??
                              Colors.black, // Cor da borda com base na área
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
                              question.area,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    areaColors[question.area] ?? Colors.black,
                              ),
                            ),
                            Text(
                              question.content,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            ...question.alternatives.map((alternative) {
                              return RadioListTile<int>(
                                title: Text(alternative.content),
                                value: alternative.id,
                                groupValue: selectedAlternatives[question.id],
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedAlternatives[question.id] = value!;
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5.0),
                  const Text("Título: "),
                  const SizedBox(height: 5.0),
                  TextField(controller: _titleController),
                  const SizedBox(height: 5.0),
                  const Text("Observações: "),
                  const SizedBox(height: 5.0),
                  TextField(
                    controller: _observationController,
                    minLines: 15,
                    maxLines: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitAnswers,
        child: const Icon(Icons.send),
      ),
    );
  }
}
