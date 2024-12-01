class Pokemon {
  final String name;
  final String url;
  bool isFavorite; // Añadir esta propiedad
  Pokemon({required this.name, required this.url, this.isFavorite = false});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}
