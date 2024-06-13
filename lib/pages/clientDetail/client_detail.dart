// ignore: file_names
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:hexagonguardians/pages/clientDetail/atecc_insights.dart';
import 'package:hexagonguardians/pages/clientDetail/list_avaliations.dart';
import 'package:hexagonguardians/pages/clientDetail/list_guardian.dart';
import 'package:hexagonguardians/pages/clientDetail/show_atec_evolution.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexagonguardians/models/client.dart';
import 'list_specialist.dart';

class ClientDetail extends StatefulWidget {
  final String id;
  final String name;

  const ClientDetail({super.key, required this.id, required this.name});

  @override
  State<ClientDetail> createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Client> fetchUsuario() async {
    final response = await http.get(
        Uri.parse('https://hexagon-no2i.onrender.com/client/${widget.id}'));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return Client.fromJson(data);
    } else {
      throw Exception('Falha ao carregar o usuário');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: FutureBuilder<Client>(
        future: fetchUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar os dados do usuário'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Usuário não encontrado'));
          } else {
            final usuario = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: usuario.imageurl != null
                          ? DecorationImage(
                              image: NetworkImage(usuario.imageurl!),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                // Se a imagem não puder ser baixada, mostre outra imagem aqui
                                const AssetImage('assets/images/logo.png');
                              },
                            )
                          : null,
                    ),
                  ),
                  Text(
                    usuario.name ?? "name not found : (",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: Colors.deepPurple[200],
                    ),
                  ),
                  Text(
                    usuario.identifier ?? "no identifier",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.deepPurple[200],
                    ),
                  ),
                  Text(
                    usuario.bio ?? "bio not found : (",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.deepPurple[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(
                        icon: Icon(Icons.person_2_outlined),
                        text: "cliente",
                      ),
                      Tab(
                        icon: Icon(Icons.auto_graph_outlined),
                        text: "progresso por área",
                      ),
                      Tab(
                        icon: Icon(Icons.list),
                        text: "avaliações atec",
                      ),
                      Tab(
                        icon: Icon(Icons.content_paste),
                        text: "profissionais",
                      ),
                      Tab(
                        icon: Icon(Icons.family_restroom),
                        text: "familiares",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        AtecInsights(clientId: "${usuario.id}"),
                        ShowAtecEvolution(clientId: "${usuario.id}"),
                        ListAvaliations(clientId: "${usuario.id}"),
                        SpecialistList(clientId: "${usuario.id}"),
                        GuardianList(clientId: "${usuario.id}"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {context.push('/atec/${widget.id}')},
        child: const Icon(
          Icons.content_paste_go_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
