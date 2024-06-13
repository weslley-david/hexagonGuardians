import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexagonguardians/models/specialist.dart';
import 'package:http/http.dart' as http;

class SpecialistList extends StatefulWidget {
  final String clientId;

  const SpecialistList({super.key, required this.clientId});

  @override
  SpecialistListState createState() => SpecialistListState();
}

class SpecialistListState extends State<SpecialistList> {
  Future<List<Specialist>> _getSpecialistList() async {
    final Map<String, String> queryParams = {
      'skip': '0',
      'take': '2',
      'client': widget.clientId
    };

    final uri = Uri.https(
        'hexagon-no2i.onrender.com', '/specialist/byclient', queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Specialist.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load specialist list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Specialists'),
      // ),
      body: FutureBuilder<List<Specialist>>(
        future: _getSpecialistList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load specialists'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No specialists found'));
          } else {
            final specialists = snapshot.data!;
            return ListView.builder(
              itemCount: specialists.length,
              itemBuilder: (context, index) {
                final specialist = specialists[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("${specialist.imageurl}"),
                  ),
                  title: Text("@${specialist.identifier}"),
                  subtitle: Text("${specialist.specialty}"),
                  onTap: () {
                    // Implement navigation or any action here if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
