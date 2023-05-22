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

class _VoteState extends State<Vote> with TickerProviderStateMixin {
  late final Future<Map<String, dynamic>> response;
  late AnimationController _linearAnimationController;
  late AnimationController _rotationAnimationController;
  late double fullslide;
  double _animationProcantage = 0;
  int currentIndex = 0;

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _linearAnimationController,
    curve: Curves.linear,
  ));

  Future<Map<String, dynamic>> get(int id) async {
    Uri url = Uri.https('koeg.000webhostapp.com', 'sop/api.php/get',
        {"id": widget.id.toString()});
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

  void vote(int id, bool isyes, List response) async {
    const url = 'https://koeg.000webhostapp.com/sop/api.php/vote';
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    await http.post(Uri.parse(url), headers: headers, body: {
      'isyes': isyes.toString(),
      'id': id.toString(),
    });

    if (currentIndex < response.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(id: widget.id),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    fullslide = MediaQuery.of(context).size.width / 4;
    _linearAnimationController = AnimationController(vsync: this);
    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
    );
    response = get(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _linearAnimationController.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onHorizontalDragStart: (details) {
                        setState(() {
                          _animationProcantage = 0;
                        });
                      },
                      onHorizontalDragUpdate: (details) {
                        setState(() {});
                      },
                      onHorizontalDragEnd: (details) {},
                      onHorizontalDragCancel: () {
                        setState(() {
                          _animationProcantage = 0;
                        });
                      },
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: RotationTransition(
                          turns: _rotationAnimationController,
                          child: Image.network(
                            'http://koeg.000webhostapp.com/sop/images/$id/${images[currentIndex]['file_Name']}',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height * 0.7,
                            height: null,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              int? expecdtByts =
                                  loadingProgress.expectedTotalBytes;
                              int? currentByts =
                                  loadingProgress.cumulativeBytesLoaded;
                              if (expecdtByts != null) {
                                var loadingProcent = currentByts / expecdtByts;
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.5 /
                                          2,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.5 /
                                              2,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
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
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width *
                                  0.7 /
                                  2.5),
                          child: SizedBox(
                            width: 80,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                vote(int.parse(images[currentIndex]['id']),
                                    false, images);
                              },
                              child: const Icon(Icons.close),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              vote(int.parse(images[currentIndex]['id']), true,
                                  images);
                            },
                            child: const Icon(Icons.done),
                          ),
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
