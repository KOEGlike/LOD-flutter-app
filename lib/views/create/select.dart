import 'dart:io';
import 'package:first_test/custom_error.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:first_test/api.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

class PickedImages {
  final Uint8List binary;
  final String extension;

  const PickedImages(this.binary, this.extension);
}

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late final TextEditingController _controller;

  bool uploading = false;

  bool hasError = false;

  List<PickedImages> images = [];
  late Future<List<File>> pickedUint8ListsFuture = Future<List<File>>.value([]);

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  Future<List<PickedImages>> pickUint8Lists() async {
    List<PickedImages> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'webp', 'jpeg'],
    );

    if (result == null) {
      return [];
    }
    if (kIsWeb) {
      files = [
        for (int i = 0; i < result.files.length; i++)
          PickedImages(result.files[i].bytes ?? Uint8List(0),
              result.files[i].extension ?? ".png")
      ];
    } else {
      files = [
        for (int i = 0; i < result.files.length; i++)
          PickedImages(File(result.files[0].path ?? "").readAsBytesSync(),
              result.files[i].extension ?? ".png")
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
            if (_controller.text != "") {
              setState(() {
                uploading = true;
              });
              late int id;
              try {
                id = await create(_controller.text);
              } on ErrorType catch (e) {
                setState(() {
                  hasError = true;
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message)));
                //Scaffold.of(context).
              }
              try {
                await upload(images, id, _controller.text);
              } on ErrorType catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
                setState(() {
                  hasError = true;
                });
              }
              setState(() {
                uploading = false;
              });
              if (context.mounted) {
                context.go("/create/links?id=$id");
              }
            }
          },
          child: SizedBox(
            width: 30,
            height: 30,
            child: hasError
                ? Icon(Icons.priority_high_rounded,
                    color: Theme.of(context).colorScheme.error)
                : uploading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSecondary,
                      )
                    : Icon(
                        Icons.publish_rounded,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
          )),
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
                      keyboardType: TextInputType.text,
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
                                    final List<PickedImages> pickedUint8Lists =
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
                                        maxCrossAxisExtent: 170,
                                        //childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (BuildContext ctx, index) {
                                  return SizedBox.shrink(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.memory(images[index].binary),
                                    ),
                                  );
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
