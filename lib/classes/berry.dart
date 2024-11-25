class Berry {
  final String name;
  final String url;

  Berry({required this.name, required this.url});

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      name: json['name'],
      url: json['url'],
    );
  }
}