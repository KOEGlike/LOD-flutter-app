import 'package:first_test/custom_error.dart';
import 'package:first_test/views/create/select.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
/*import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:typed_data';*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> get(int? id) async {
  if (id == null) return null;
  Uri url = Uri.https(
      'koeg.000webhostapp.com', 'sop/api.php/get', {"id": id.toString()});

  late http.Response response;
  try {
    response = await http.get(url);
  } on http.ClientException catch (e) {
    throw Future.error(ErrorType(e.message));
  }
  final Map<String, dynamic>? body = jsonDecode(response.body);
  if (body?["name"] == "" || body?["name"] == null) {
    return null;
  }

  return body;
}

Future<void> vote(int id, bool isyes, List response) async {
  Uri url = Uri.http('koeg.000webhostapp.com', 'sop/api.php/vote');
  http.MultipartRequest request = http.MultipartRequest("POST", url);
  request.fields["isyes"] = isyes.toString();
  request.fields["id"] = id.toString();

  late http.StreamedResponse streamedResponse;
  try {
    streamedResponse = await request.send();
  } on http.ClientException catch (e) {
    throw ErrorType(e.message);
  }

  late http.Response response;
  try {
    response = await http.Response.fromStream(streamedResponse);
  } on http.ClientException catch (e) {
    throw ErrorType(e.message);
  }

  debugPrint(response.statusCode.toString());
  if (response.statusCode != 200) {
    throw ErrorType(jsonDecode(response.body)['message'].toString());
  }
}

Future<void> upload(
  List<PickedImages> images,
  int id,
  String name,
) async {
  Uri url = Uri.http('koeg.000webhostapp.com', 'sop/api.php/upload/image');

  for (int i = 0; i < images.length; i++) {
    http.MultipartRequest request = http.MultipartRequest("POST", url);

    request.files.add(
      http.MultipartFile.fromBytes('file', images[i].binary,
          contentType: MediaType(
            "image",
            images[i].extension,
          ),
          filename: "$name$i.${images[i].extension}"),
    );
    request.fields["id"] = id.toString();

    late http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await request.send();
    } on http.ClientException catch (e) {
      throw ErrorType(e.message);
    }

    late http.Response response;
    try {
      response = await http.Response.fromStream(streamedResponse);
    } on http.ClientException catch (e) {
      throw ErrorType(e.message);
    }

    if (response.statusCode != 200) {
      throw ErrorType(jsonDecode(response.body)['message'].toString());
    }
  }
}

Future<int> create(String name) async {
  Uri url = Uri.http('koeg.000webhostapp.com', 'sop/api.php/upload/create');
  http.MultipartRequest request = http.MultipartRequest("POST", url);
  request.fields["name"] = name;
  http.StreamedResponse streamedResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamedResponse);
  debugPrint(response.statusCode.toString());
  if (response.statusCode != 200) {
    throw ErrorType(jsonDecode(response.body)["message"]);
  } else {
    return int.parse(jsonDecode(response.body)["id"]);
  }
}
