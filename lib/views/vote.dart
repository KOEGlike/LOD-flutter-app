import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vote extends StatefulWidget {
  final int id;
  const Vote({super.key, required this.id});

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('${widget.id}'),
    );
  }
}
