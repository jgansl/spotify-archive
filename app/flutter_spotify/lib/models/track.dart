class Track {
  final String id;
  final String name;
  // final Data data;

  Track({
    required this.id,
    required this.name,
    // required this.data,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['track']['id'],
      name: json['track']['name'],
    );
  }
}
