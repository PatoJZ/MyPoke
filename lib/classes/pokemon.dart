class Pokemon {
  final String name;
  final String url;
  bool isFavorite;

  Pokemon({required this.name, required this.url, this.isFavorite = false});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }

  int get id {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]); // Obtiene el ID de la URL
  }
}