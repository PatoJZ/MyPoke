import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_browser/classes/pokemon.dart';
import 'package:pokemon_browser/details/pokedetail.dart';

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

 
  Future<List<Pokemon>> fetchPokemons({int limit = 1000, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching pokemons: ${response.statusCode}');
    }
  }

  Future<Pokemon> fetchPokemonByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson({
        'name': data['name'],
        'url': '$baseUrl/pokemon/${data['id']}',
      });
    } else {
      throw Exception('Error fetching pokemon by name: ${response.statusCode}');
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

  Future<List<Pokemon>> fetchPokemonsByPartialName(String query) async {
    final limit = 1000; 
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

     
      final filteredPokemons = results
          .where((pokemon) =>
              pokemon['name'].toLowerCase().contains(query.toLowerCase()))
          .map((json) => Pokemon.fromJson(json))
          .toList();

      return filteredPokemons;
    } else {
      throw Exception('Error fetching pokemons: ${response.statusCode}');
    }
  }
}
