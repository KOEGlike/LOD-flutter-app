import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:first_test/api.dart';
import 'package:flutter/services.dart';

class Links extends StatefulWidget {
  final int id;

  const Links({Key? key, required this.id}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  late Future<Map<String, dynamic>> response;
  late final TextEditingController _controllerLink;
  late final TextEditingController _controllerId;

  Future<void> copyToClipBoard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void initState() {
    _controllerLink = TextEditingController(
        text: "http://koeg.000webhostapp.com/lod/#/vote?id=${widget.id}");
    _controllerId = TextEditingController(text: widget.id.toString());
    response = get(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _controllerLink.dispose();
    _controllerId.dispose();
    super.dispose();
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
        title: FutureBuilder<Map<String, dynamic>>(
          future: response,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final String name = snapshot.data!['name'];
              return Text(name);
            } else {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 450,
                    child: TextField(
                      controller: _controllerLink,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'LOD link',
                      ),
                      enabled: false,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    copyToClipBoard(_controllerLink.text);
                  },
                  child: const Text("Copy!"),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _controllerId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'LOD id',
                    ),
                    enabled: false,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  copyToClipBoard(_controllerId.text);
                },
                child: const Text("Copy!"),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
