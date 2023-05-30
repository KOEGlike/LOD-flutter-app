import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late final TextEditingController _controller;
  List<File> images = [];
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  Future<List<File>> pickImages() async {
    List<File> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {}

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
                  width: 400,
                  child: ExpansionTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Photos"),
                        IconButton(
                            onPressed: () {
                              //images = images + pickImages();
                            },
                            icon: const Icon(Icons.add_circle_outline))
                      ],
                    ),
                    children: [
                      SizedBox(
                        width: 400,
                        height: 700,
                        child: FutureBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemBuilder: (BuildContext ctx, index) {
                                return Image.file(images[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
