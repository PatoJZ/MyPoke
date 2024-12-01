class PokemonDetail {
  final String name;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final String spriteUrl;

  PokemonDetail({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.spriteUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List)
        .map((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    return PokemonDetail(
      name: json['name'],
      id: json['id'],
      height: json['height'],
      weight: json['weight'],
      types: types,
      spriteUrl: json['sprites']['front_default'],
    );
  }
}