import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Results extends StatefulWidget {
  final int id;
  const Results({Key? key, required this.id}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late Future<Map<String, dynamic>> response;

  Future<Map<String, dynamic>> get(int id) async {
    Uri url = Uri.https('koeg.000webhostapp.com', 'sop/api.php/get',
        {"id": widget.id.toString()});
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    response = get(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final images = snapshot.data!['images'];
          final name = snapshot.data!['name'];
          final id = widget.id;

          return Scaffold(
            appBar: AppBar(actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.refresh_rounded))
            ]),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class ImageResults extends StatefulWidget {
  final List<Map<String, dynamic>> image;

  const ImageResults({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageResults> createState() => _ImageResultsState();
}

class _ImageResultsState extends State<ImageResults> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.network(
            'http://koeg.000webhostapp.com/sop/images/${widget.image[origin_Id]}/${image['file_Name']}',

            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.height *
                0.76, // set width to 90% of screen width
            height: null,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              int? expecdtByts = loadingProgress.expectedTotalBytes;
              int? currentByts = loadingProgress.cumulativeBytesLoaded;
              if (expecdtByts != null) {
                var loadingProcent = currentByts / expecdtByts;
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5 / 2,
                      bottom: MediaQuery.of(context).size.height * 0.5 / 2,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: LinearProgressIndicator(
                        value: loadingProcent,
                      ),
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
          ),
        ],
      ),
    );
  }
}
