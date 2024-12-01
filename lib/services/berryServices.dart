import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_browser/classes/berry.dart'; 
import 'package:pokemon_browser/details/berrydetail.dart';

class BerryService {
  final String baseUrl = "https://pokeapi.co/api/v2/berry/";

  //obtener el detalle de una berry
  Future<BerryDetail> fetchBerryDetail(String berryId) async {
    final response = await http.get(Uri.parse('$baseUrl$berryId/'));

    if (response.statusCode == 200) {
      return BerryDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load berry details');
    }
  }

  //obtener todas las berries
  Future<List<Berry>> fetchBerries() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((item) => Berry.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load berries');
    }
  }
}
