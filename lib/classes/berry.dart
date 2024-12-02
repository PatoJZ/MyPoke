class Berry {
  final String name;
  final String url;
  bool isFavorite;

  Berry({required this.name, required this.url, this.isFavorite = false});

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      name: json['name'],
      url: json['url'],
    );
  }

  int get id {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]); // Obtiene el ID de la URL
  }
}