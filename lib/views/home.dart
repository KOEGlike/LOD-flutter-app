import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    _controller.addListener(() {
      if (_controller.text.contains('\n')) {
        // Enter key pressed, perform desired action here
        debugPrint('Enter key pressed');

        // Clear the text field
        _controller.clear();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void redirectToVote() {
    if (_controller.text != "") {
      context.go('/vote?id=${int.parse(_controller.text)}');
    }
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
                onSubmitted: (value) {
                  redirectToVote();
                },
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'LOD id',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 70,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    redirectToVote();
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
