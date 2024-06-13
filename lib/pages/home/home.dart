import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexagonguardians/models/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('acetoken');
  }

  int _skip = 0;
  final int _take = 10;

  Future<List<Client>> _getClientList() async {
    final Map<String, String> queryParams = {
      'skip': '$_skip',
      'take': '$_take',
      "specialist": '1',
    };
    String? token = await getAccessToken();
    final uri = Uri.https(
        'hexagon-no2i.onrender.com', '/client/byguardian', queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Client.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load client list');
    }
  }

  void _loadPreviousPage() {
    if (_skip >= _take) {
      setState(() {
        _skip -= _take;
      });
    }
  }

  void _loadNextPage() {
    setState(() {
      _skip += _take;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text("acompanhar"),
          actions: const [
            Image(image: AssetImage('assets/images/logo.png')),
          ]),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text('v 0.1.0 (^~^)'),
            ),
            ListTile(
              title: const Text('Adicionar cliente'),
              onTap: () {
                context.push('/addclient');
              },
              leading: const Icon(Icons.add),
            ),
            ListTile(
              title: const Text('Remover cliente'),
              onTap: () {
                context.push('/removeclient');
              },
              leading: const Icon(Icons.remove),
            ),
            ListTile(
              title: const Text('Cadastrar'),
              onTap: () {
                context.push('/createclient');
              },
              leading: const Icon(
                Icons.edit_outlined,
              ),
            ),
            ListTile(
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                SystemNavigator.pop();
              },
              leading: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _getClientList(),
                builder: (context, AsyncSnapshot<List<Client>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Center(
                          child: Text(
                              'Aqui parece meio vazio... Tente adicionar alguém no menu ao lado'));
                    }

                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xFF070707),
                            ),
                            //padding: EdgeInsets.all(20.0),
                            margin: const EdgeInsets.all(2.0),
                            child: ListTile(
                              onTap: () => {
                                context.push(
                                    '/detailclient/${snapshot.data![index].id}/${snapshot.data![index].identifier}')
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                        .data![index].imageurl ??
                                    "https://hexagon-no2i.onrender.com/static/client.png"),
                              ),
                              title: Text(
                                '@${snapshot.data![index].identifier}',
                              ),
                              subtitle: Text(
                                snapshot.data![index].name ?? "not found",
                              ),
                              // trailing: TextButton(
                              //   child: const Icon(
                              //     Icons.content_paste_go_rounded,
                              //   ),
                              //   onPressed: () => {},
                              // ),
                            ),
                          );
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _loadPreviousPage,
                  child: const Text('<<'),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Text('$_skip / ${_take + _skip}'),
                const SizedBox(
                  width: 15.0,
                ),
                TextButton(
                  onPressed: _loadNextPage,
                  child: const Text('>>'),
                ),
                const SizedBox(
                  width: 15.0,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
