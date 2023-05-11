import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 200,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'LOD id',
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 70,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    print(_controller.text);
                  },
                  child: const Text('Start'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
