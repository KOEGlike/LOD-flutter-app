import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vote extends StatefulWidget {
  final int id;
  const Vote({super.key, required this.id});

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  late final List images;

  Future<Map<String, String>> get(int id) async {
    var url = Uri.https(
        'example.com', 'whatsit/create', {"id": widget.id.toString()});
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return Future;
    jsonDecode(response);
  }

  void vote(int id, bool isyes) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('${widget.id}'),
    );
  }
}
