import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexagonguardians/models/atec_result.dart';
import 'package:http/http.dart' as http;

class AtecInsights extends StatefulWidget {
  final String clientId;
  const AtecInsights({super.key, required this.clientId});

  @override
  State<AtecInsights> createState() => _AtecInsightsState();
}

class _AtecInsightsState extends State<AtecInsights> {
  Future<List<AtecResult>> _getAtecResultsList() async {
    final Map<String, String> queryParams = {'client': widget.clientId};

    final uri = Uri.https(
        'hexagon-no2i.onrender.com', '/atec/resultoflasttest', queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => AtecResult.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load guardian list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AtecResult>>(
        future: _getAtecResultsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load ATEC results'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ATEC results found'));
          } else {
            final results = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'ATEC Results',
                    //style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ListTile(
                        title: Text("${result.area} : ${result.pontuation}"),
                        //subtitle: Text("${result.pontuation}"),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
