import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:first_test/api.dart';
import '../custom_error.dart';

class ResultsPage extends StatefulWidget {
  final int? id;
  const ResultsPage({super.key, required this.id});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late Future<Map<String, dynamic>?> response;

  void reload() {
    setState(() {
      response = get(widget.id);
    });
  }

  @override
  void initState() {
    response = get(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: response,
      builder: (context, snapshot) {
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

          return Scaffold(
              appBar: AppBar(
                title: Text('$name results'),
                leading: IconButton(
                  onPressed: () {
                    context.go("/");
                  },
                  icon: const Icon(Icons.arrow_back_sharp),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        reload();
                      },
                      icon: const Icon(Icons.refresh_rounded))
                ],
              ),
              body: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.builder(
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ImageResults(
                          originId: int.parse(images[index]['origin_Id']),
                          fileName: images[index]['file_Name'],
                          score: int.parse(images[index]['votes']),
                          votesAmount: int.parse(images[index]['votes_amount']),
                        );
                      }),
                ),
              ));
        } else {
          return const CustomErrorView(ErrorTypes.pageDoseNotExist);
        }
      },
    );
  }
}

class ImageResults extends StatefulWidget {
  final int originId;
  final String fileName;
  final int score;
  final int votesAmount;

  const ImageResults(
      {super.key,
      required this.originId,
      required this.fileName,
      required this.score,
      required this.votesAmount});

  @override
  State<ImageResults> createState() => _ImageResultsState();
}

class _ImageResultsState extends State<ImageResults> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'http://koeg.000webhostapp.com/lod/api/images/${widget.originId}/${widget.fileName}',

                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width *
                    0.15, // set width to 90% of screen width
                height: null,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  int? expecdtByts = loadingProgress.expectedTotalBytes;
                  int? currentByts = loadingProgress.cumulativeBytesLoaded;
                  if (expecdtByts != null) {
                    var loadingProcent = currentByts / expecdtByts;
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.0001,
                        child: LinearProgressIndicator(
                          value: loadingProcent,
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
          Text('Score:\n${widget.score}'),
          Text('Amount of votes:\n${widget.votesAmount}'),
          Text(
              'Percantage:\n${(((widget.score / widget.votesAmount) * 100 + 100) / 2).toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
