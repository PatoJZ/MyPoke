import 'package:flutter/material.dart';
import 'package:pokemon_browser/details/pokedetail.dart'; 
import 'package:pokemon_browser/services/pokeServices.dart';
import 'package:cached_network_image/cached_network_image.dart';


class PokemonDetailScreen extends StatefulWidget {
  final String pokemonId;

  const PokemonDetailScreen({Key? key, required this.pokemonId}) : super(key: key);

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<PokemonDetail> pokemonDetailFuture;

  @override
  void initState() {
    super.initState();
    pokemonDetailFuture = PokemonService().fetchPokemonDetail(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Pokémon'),
      ),
      body: FutureBuilder<PokemonDetail>(
        future: pokemonDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró información'));
          }

          final pokemon = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${pokemon.name}', style: const TextStyle(fontSize: 18)),
                  Text('ID: ${pokemon.id}', style: const TextStyle(fontSize: 18)),
                  Text('Altura: ${pokemon.height}', style: const TextStyle(fontSize: 18)),
                  Text('Peso: ${pokemon.weight}', style: const TextStyle(fontSize: 18)),
                  Text('Tipos: ${pokemon.types.join(', ')}', style: const TextStyle(fontSize: 18)),

                  const SizedBox(height: 16),
                  CachedNetworkImage(
                    imageUrl: pokemon.spriteUrl,
                    width: 200,
                    height: 200,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red, size: 48),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
