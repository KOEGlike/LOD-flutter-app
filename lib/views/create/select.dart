import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:first_test/api.dart';
import 'package:go_router/go_router.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late final TextEditingController _controller;

  List<Uint8List> images = [];
  late Future<List<File>> pickedUint8ListsFuture = Future<List<File>>.value([]);

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  Future<List<Uint8List>> pickUint8Lists() async {
    List<Uint8List> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'webp', 'jpeg'],
    );

    if (result != null) {
      files = [
        for (int i = 0; i < result.files.length; i++)
          result.files[i].bytes ?? Uint8List(0)
      ];
    }
    return files;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int id = await create(_controller.text);
          debugPrint(id.toString());
          debugPrint(id.toString());
          upload(images, id);
          if (context.mounted) {
            context.go("create/links?=$id");
          }
        },
        child: Icon(
          Icons.publish_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name Of LOD',
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 600,
                  child: FutureBuilder(
                    future: pickedUint8ListsFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return Theme(
                        data: ThemeData(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          textColor: Theme.of(context).colorScheme.secondary,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          collapsedIconColor:
                              Theme.of(context).colorScheme.primary,
                          collapsedTextColor:
                              Theme.of(context).colorScheme.primary,
                          maintainState: true,
                          initiallyExpanded: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Photos"),
                              IconButton(
                                onPressed: () async {
                                  if (snapshot.hasData) {
                                    final List<Uint8List> pickedUint8Lists =
                                        await pickUint8Lists();

                                    setState(() {
                                      images = images + pickedUint8Lists;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              )
                            ],
                          ),
                          children: [
                            SizedBox(
                              width: 400,
                              height: 700,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 250,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemBuilder: (BuildContext ctx, index) {
                                  return Image.memory(images[index]);
                                },
                                itemCount: images.length,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
