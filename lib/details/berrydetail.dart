import 'dart:convert';

import 'package:pokemon_browser/DataBase/db_helper.dart';

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
  
  get http => null;
  Future<BerryDetail> fetchBerryDetail(String berryId) async {
    final String url = "https://pokeapi.co/api/v2/berry/$berryId/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final berryDetail = BerryDetail.fromJson(data);

        // Guardar en SQLite
        await DBHelper().insertBerry({
          'id': berryDetail.id,
          'name': berryDetail.name,
          'firmness': berryDetail.firmness,
          'growth_time': berryDetail.growthTime,
          'max_harvest': berryDetail.maxHarvest,
          'size': berryDetail.size,
          'smoothness': berryDetail.smoothness,
          'natural_gift_type': berryDetail.naturalGiftType,
          'natural_gift_power': berryDetail.naturalGiftPower,
          'image_url': berryDetail.imageUrl,
          'is_favorite': 0,
        });

        return berryDetail;
      } else {
        throw Exception('Error al cargar el detalle de la berry');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
