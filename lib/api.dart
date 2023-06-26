import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> get(int id) async {
  Uri url = Uri.https(
      'koeg.000webhostapp.com', 'sop/api.php/get', {"id": id.toString()});
  http.Response response = await http.get(url);
  return jsonDecode(response.body);
}

void vote(int id, bool isyes, List response) async {
  const url = 'https://koeg.000webhostapp.com/sop/api.php/vote';
  final headers = {'Content-Type': 'multipart/form-data'};

  await http.post(Uri.parse(url), headers: headers, body: {
    'isyes': isyes.toString(),
    'id': id.toString(),
  });
}

void upload(List<Uint8List> images, int id) async {
  Uri url = Uri.http('koeg.000webhostapp.com', 'sop/api.php/upload/image');

  for (int i = 0; i < images.length; i++) {
    http.MultipartRequest request = http.MultipartRequest("POST", url);
    request.files.add(http.MultipartFile.fromBytes("file", images[i]));
    request.fields["id"] = id.toString();
    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200) {
      Exception(jsonDecode(response.body)['message'].toString());
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
    Exception(jsonDecode(response.body)["message"]);
    return -1;
  } else {
    return int.parse(jsonDecode(response.body)["id"]);
  }
}
