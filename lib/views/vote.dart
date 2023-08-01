import 'package:first_test/api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../custom_error.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class Vote extends StatefulWidget {
  final int? id;
  const Vote({Key? key, required this.id}) : super(key: key);

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  late Future<Map<String, dynamic>?> response;

  final CardSwiperController _controller = CardSwiperController();

  @override
  void didChangeDependencies() {
    response = get(widget.id);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: response,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (widget.id == null) {
          return const CustomErrorView(ErrorTypes.pageDoseNotExist);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.data == null) {
          return const CustomErrorView(ErrorTypes.pageDoseNotExist);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<dynamic> images = snapshot.data!['images'];
          if (snapshot.data!['name'] == null) {
            return const CustomErrorView(ErrorTypes.pageDoseNotExist);
          }
          final String name = snapshot.data!['name'];

          final int? id = widget.id;

          return Scaffold(
            appBar: AppBar(
              title: Text(name),
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: CardSwiper(
                      numberOfCardsDisplayed: 1,
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 20,
                        right: 20,
                      ),
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
                        context.go('/results?id=$id');
                      },
                      cardBuilder: (context, index, horizontalOffsetPercentage,
                          verticalOffsetPercentage) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'http://koeg.000webhostapp.com/lod/api/images/$id/${images[index]['file_Name']}',
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter,
                            loadingBuilder: (context, child, loadingProgress) {
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
                                      top: MediaQuery.of(context).size.height *
                                          0.5 /
                                          2,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.5 /
                                              2,
                                    ),
                                    child: SizedBox(
                                      width: 150,
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
