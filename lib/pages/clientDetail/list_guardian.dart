import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexagonguardians/models/guardian.dart';

class GuardianList extends StatefulWidget {
  final String clientId;

  const GuardianList({super.key, required this.clientId});

  @override
  State<GuardianList> createState() => _GuardianListState();
}

class _GuardianListState extends State<GuardianList> {
  Future<List<Guardian>> _getGuardianList() async {
    final Map<String, String> queryParams = {
      'skip': '0',
      'take': '2',
      'client': widget.clientId
    };

    final uri = Uri.https(
        'hexagon-no2i.onrender.com', '/guardian/byclient', queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Guardian.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load guardian list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Guardian>>(
        future: _getGuardianList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load guardians'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No guardians found'));
          } else {
            final guardian = snapshot.data!;
            return ListView.builder(
              itemCount: guardian.length,
              itemBuilder: (context, index) {
                final guardians = guardian[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("${guardians.imageurl}"),
                  ),
                  title: Text("@${guardians.identifier}"),
                  subtitle: Text("${guardians.bio}"),
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
