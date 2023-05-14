import 'dart:convert';
import 'package:first_test/views/results.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vote extends StatefulWidget {
  final int id;
  const Vote({Key? key, required this.id}) : super(key: key);

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  late final Future<Map<String, dynamic>> response;
  int currentIndex = 0;

  Future<Map<String, dynamic>> get(int id) async {
    var url = Uri.https('koeg.000webhostapp.com', 'sop/api.php/get',
        {"id": widget.id.toString()});
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  void vote(int id, bool isyes, List response) async {
    if (currentIndex < response.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Results(),
        ),
      );
    }
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
            appBar: AppBar(title: Text(name)),
            body: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                      'http://koeg.000webhostapp.com/sop/images/$id/${images[currentIndex]['file_Name']}',
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        int? expecdtByts = loadingProgress.expectedTotalBytes;
                        int? currentByts =
                            loadingProgress.cumulativeBytesLoaded;
                        if (expecdtByts != null) {
                          var loadingProcent = currentByts / expecdtByts;
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    0.7 /
                                    2,
                                bottom: MediaQuery.of(context).size.height *
                                    0.7 /
                                    2,
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
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.height *
                          0.7, // set width to 90% of screen width
                      height:
                          null, // set height to null to allow scaling up or down
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height *
                                  0.7 /
                                  2.5),
                          child: ElevatedButton(
                            onPressed: () {
                              vote(int.parse(images[currentIndex]['id']), true,
                                  images);
                            },
                            child: const Text("👍"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            vote(int.parse(images[currentIndex]['id']), false,
                                images);
                          },
                          child: const Text("👎"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
