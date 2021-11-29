import 'artist.dart';

class Track {
  final String id;
  final String name;
  final List<Artist> artists; //ref
  // int duration_ms;

  Track({ required this.id, required this.name, required this.artists});

  factory Track.fromJson(Map<String, dynamic> json) {
    var list = json['track']['artists'] as List;
    // print(list.runtimeType); //returns List<dynamic>
    List<Artist> artistList = list.map((i) => Artist.fromJson(i)).toList();
    return Track(
      id: json['track']['id'],
      name: json['track']['name'],
      artists: artistList,//json['track']['artists'],
    );
  }
}