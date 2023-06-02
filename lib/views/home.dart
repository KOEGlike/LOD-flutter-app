import 'package:flutter/material.dart';
import 'package:first_test/views/vote.dart';

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
    _controller.addListener(() {
      final String text = _controller.text.replaceAll(RegExp(r"\D"), "");
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

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
                    if (_controller.text != "") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Vote(id: int.parse(_controller.text)),
                        ),
                      );
                    }
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
