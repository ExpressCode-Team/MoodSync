class Track {
  final String id;
  final String title;
  final String artist;
  final String image;
  final String url;
  final String type;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.image,
    required this.url,
    required this.type,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      title: json['name'],
      artist: json['artist'],
      image: json['images'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'artist': artist,
      'images': image,
      'url': url,
      'type': type,
    };
  }
}
