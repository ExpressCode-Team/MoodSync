class Playlist {
  final String id;
  final String name;
  final String description;
  final String image;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'No description available',
      image: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : 'https://via.placeholder.com/150',
    );
  }

  @override
  String toString() {
    return 'Playlist{id: $id, name: $name, description: $description, image: $image}';
  }
}
