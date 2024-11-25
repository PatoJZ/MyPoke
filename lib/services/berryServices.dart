import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_browser/classes/berry.dart';
import 'package:pokemon_browser/details/berrydetail.dart'; // Importar el modelo de Berry

class BerryService {
  static const String baseUrl = "https://pokeapi.co/api/v2/berry";
  Future<BerryDetail> fetchBerryDetail(String berryId) async {
    final String url = "https://pokeapi.co/api/v2/berry/$berryId/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BerryDetail.fromJson(data);
      } else {
        throw Exception('Error al cargar el detalle de la berry');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
  // Obtener todas las berries sin límite
  Future<List<Berry>> fetchBerries() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((e) => Berry.fromJson(e)).toList();
      } else {
        throw Exception('Error al cargar las berries');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
