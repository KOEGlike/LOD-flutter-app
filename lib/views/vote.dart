import 'dart:convert';
import 'package:first_test/views/results.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class Vote extends StatefulWidget {
  final int id;
  const Vote({Key? key, required this.id}) : super(key: key);

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  late Future<Map<String, dynamic>> response;

  final CardSwiperController _controller = CardSwiperController();

  Future<Map<String, dynamic>> fetchImages(int id) async {
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
  }

  @override
  void didChangeDependencies() {
    response = fetchImages(widget.id);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<dynamic> images = snapshot.data!['images'];
          final String name = snapshot.data!['name'];
          final int id = widget.id;

          debugPrint(jsonEncode(images));
          return Scaffold(
            appBar: AppBar(
              title: TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(name),
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    child: CardSwiper(
                      padding: const EdgeInsets.all(8.0),
                      allowedSwipeDirection:
                          AllowedSwipeDirection.only(right: true, left: true),
                      cardsCount: images.length,
                      controller: _controller,
                      onSwipe: (previousIndex, currentIndex, direction) {
                        if (direction == CardSwiperDirection.right) {
                          vote(int.parse(images[currentIndex ?? 0]['id']), true,
                              images);
                          debugPrint('yes');
                        } else {
                          vote(int.parse(images[currentIndex ?? 0]['id']),
                              false, images);
                          debugPrint('no');
                        }

                        return true;
                      },
                      onEnd: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsPage(id: id),
                          ),
                        );
                      },
                      cardBuilder: (context, index) {
                        return Container(
                          color: Theme.of(context).colorScheme.background,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'http://koeg.000webhostapp.com/sop/images/$id/${images[index]['file_Name']}',
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.height * 0.7,
                              height: null,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                int? expectedBytes =
                                    loadingProgress.expectedTotalBytes;
                                int? currentBytes =
                                    loadingProgress.cumulativeBytesLoaded;
                                if (expectedBytes != null) {
                                  var loadingPercent =
                                      currentBytes / expectedBytes;

                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.5 /
                                                2,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.5 /
                                                2,
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: LinearProgressIndicator(
                                          value: loadingPercent,
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
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right:
                                MediaQuery.of(context).size.width * 0.7 / 2.5,
                          ),
                          child: SizedBox(
                            width: 80,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.swipeLeft();
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
                              _controller.swipeRight();
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
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
