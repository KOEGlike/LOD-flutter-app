import 'package:first_test/views/create/select.dart';
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
  http.Response response = await http.get(url);
  return jsonDecode(response.body);
}

void vote(int id, bool isyes, List response) async {
  Uri url = Uri.http('koeg.000webhostapp.com', 'sop/api.php/vote');
  http.MultipartRequest request = http.MultipartRequest("POST", url);
  request.fields["isyes"] = isyes.toString();
  request.fields["id"] = id.toString();
  late http.StreamedResponse streamedResponse;
  try {
    streamedResponse = await request.send();
  } on http.ClientException catch (e) {}

  late http.Response response;
  try {
    response = await http.Response.fromStream(streamedResponse);
  } catch (e) {}
  debugPrint(response.statusCode.toString());
  if (response.statusCode != 200) {
    throw jsonDecode(response.body)["message"];
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
    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['message'].toString();
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
    throw jsonDecode(response.body)["message"];
  } else {
    return int.parse(jsonDecode(response.body)["id"]);
  }
}
