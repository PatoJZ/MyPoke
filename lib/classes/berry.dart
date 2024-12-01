class Berry {
  final String name;
  final String url;
  bool isFavorite; // Nueva variable

  Berry({required this.name, required this.url, this.isFavorite = false});

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      name: json['name'],
      url: json['url'],
    );
  }
}