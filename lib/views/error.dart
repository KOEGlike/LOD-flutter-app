import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Errores extends StatelessWidget {
  final String errorType;
  const Errores(this.errorType, {super.key});

  Widget error(String errorType) {
    switch (errorType) {
      case "not_exist":
        return const Text("This page dose not exist");

      default:
        return const Text("This page dose not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go("/home");
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: Center(
        child: error(errorType),
      ),
    );
  }
}
