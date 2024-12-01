class BerryDetail {
  final String name;
  final int id;
  final String firmness;
  final int growthTime;
  final int maxHarvest;
  final int size;
  final int smoothness;
  final String naturalGiftType;
  final int naturalGiftPower;
  final String imageUrl;

  BerryDetail({
    required this.name,
    required this.id,
    required this.firmness,
    required this.growthTime,
    required this.maxHarvest,
    required this.size,
    required this.smoothness,
    required this.naturalGiftType,
    required this.naturalGiftPower,
    required this.imageUrl,
  });

  factory BerryDetail.fromJson(Map<String, dynamic> json) {
    //  URL de la imagen
    final berryImageUrl =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/berries/${json['name'].toLowerCase()}-berry.png";

    return BerryDetail(
      name: json['name'],
      id: json['id'],
      firmness: json['firmness']['name'],
      growthTime: json['growth_time'],
      maxHarvest: json['max_harvest'],
      size: json['size'],
      smoothness: json['smoothness'],
      naturalGiftType: json['natural_gift_type']['name'],
      naturalGiftPower: json['natural_gift_power'],
      imageUrl: berryImageUrl,
    );
  }
}
