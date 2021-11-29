import 'package:flutter_spotify/spotify/spotify_web.dart';

class Artist {
  final String id;
  final String name;
  List<String>? genres = [];


  static Future<List<Artist>> fetch(artists) async { // method
    var data = await fetchArtists(artists);
    // var artists = [];
    // for(int i= 0; i < data['artists'].length; i++){
    //   artists.add(data[i]);
    // }
    return data;
  }

  Artist({ required this.id, required this.name, this.genres});

  //fill in info if missing
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      genres: json['genres'],
    );
  }
}