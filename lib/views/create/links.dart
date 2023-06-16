import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Links extends StatefulWidget {
  const Links({super.key});

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('lol'),
      ),
    );
  }
}
