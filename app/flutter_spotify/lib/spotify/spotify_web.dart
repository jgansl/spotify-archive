import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_spotify/spotify/models/models.dart';
import 'package:flutter_spotify/spotify/models/models.dart';
import "dart:developer";

String base = 'https://api.spotify.com/v1';
// var endpoints = {
//   me:{},
// }

Future _request(String url) async {
  var data = [];
  var response = await http
      .get(Uri.parse(url), headers: {
    "Authorization": 'Bearer BQD5SiiQcgsWQSesHYe47wwZ6mtphkJDMc8uVZwuc04-2_v5dqszOzad5zLgiyMd35scr9A0asAh6W9-1sTmg1bUgdG7uU4v9ZMnKYuqme7n49iOpyFoNsDVyOfdrKVstRZ7jvr559dDx213lvEkrX0TjanJrAQ-EdGC4J1RSkFeBtnnprJygcdfZuDsQBKb0IXp9qYegZkjCm4IYtKUMBTtL0-jnhMoW-B-ZzQDuQ2n4SR99h9m-YYdTDbqrxIF9IVGUVU6GeT_mcjqvsxrqcrkYA3kHmi0U75EAS2x4xC1_doyhri0',
  },);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch data: ${response.body}');
  }

}

Future<List<Artist>> fetchArtists(data) async { //assume artist data from 'track''artists' of some sort
  final List<Artist> data = [];
  String url = "$base/artists?offset=${data.map((item)=>item.id).toList().join(',')}";
  var res = await _request(url);
  res = res['artists'];
  var json = res; //! extra line
  //return data['items'];
  for (var i = 0; i < json.length; i++) {
    data.add(Artist.fromJson(json[i])); //TODO map(() => ).toList()
  }
  return data;
}

Future<List<Track>> fetchTracks(url) async {
  final List<Track> data = [];
  url ??= "$base/tracks/?";
  var res = await _request(url);
  var json = res['items'];
  for (var i = 0; i < json.length; i++) {
    data.add(Track.fromJson(json[i]));
  }
  return data;
}

Future<List<Track>> fetchSaved(int offset) async { //<List<Track>>
  //TODO store total and prevent, timeout
  final List<Track> data = [];
  String url = "$base/me/tracks?offset=$offset";
  var res = await _request(url);
  var json = res['items'];
  for (var i = 0; i < json.length; i++) {
    data.add(Track.fromJson(json[i]));
  }
  return data;
  //return data.map((i)=>Track.fromJson(i)).toList();
}

Future<List<Track>> fetchRecentlyPlayed() async {
  String url = "$base/me/player/recently-played";
  // if (after != null) {
  //   url += '?after=$after'; //timestamp, before
  // }
  final List<Track> data = [];
  var res = await _request(url);
  var json = res['items'];
  for (var i = 0; i < json.length; i++) {
    data.add(Track.fromJson(json[i]));
  }

  return data;
}