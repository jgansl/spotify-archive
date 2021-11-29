import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/**
 * https://pub.dev/packages/http
 */

//ENDPONTS

//SCOPE

class SpotifyWebClient {
  var baseUrl = 'https://example.com/whatsit/create/';
  String? token;

  SpotifyWebClient(this.token);

  // async Future<String> _request(String endpoint, method) {
  //   var url = Uri.parse('${baseUrl}${endpoint}');
  //
  //   // var response = await client.post(url, body: {'name': 'doodle', 'color': 'blue'});
  //   await client.post(
  //       Uri.https('example.com', 'whatsit/create'),
  // }

  var client = http.Client();

  void _request(String endpoint, String method) {
    // try {
    // var response = await client.post(
    // Uri.https('example.com', 'whatsit/create'),
    // body: {'name': 'doodle', 'color': 'blue'});
    // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    // var uri = Uri.parse(decodedResponse['uri'] as String);
    // print(await client.get(uri));
    // } finally {
    // client.close();
    // }
    return;
  }

  void refreshToken() {
    token = "newtoken";
  }

  String getToken() {
    return token!;
  }
}
