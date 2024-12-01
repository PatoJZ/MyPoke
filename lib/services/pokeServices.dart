import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_browser/classes/pokemon.dart'; 
import 'package:pokemon_browser/details/pokedetail.dart';

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=10000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching pokemons: ${response.statusCode}');
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(String pokemonId) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$pokemonId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      throw Exception('Error fetching pokemon detail: ${response.statusCode}');
    }
  }
}