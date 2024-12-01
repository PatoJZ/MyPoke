import 'package:flutter/material.dart';
import 'package:pokemon_browser/classes/pokemon.dart'; 
import 'package:pokemon_browser/services/pokeServices.dart';
import 'PokemonDetailScreen.dart';




class PokemonsScreen extends StatefulWidget {
  const PokemonsScreen({Key? key}) : super(key: key);

  @override
  _PokemonsScreenState createState() => _PokemonsScreenState();
}

class _PokemonsScreenState extends State<PokemonsScreen> {
  late Future<List<Pokemon>> pokemonsFuture;

  @override
  void initState() {
    super.initState();
    pokemonsFuture = PokemonService().fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémons'),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: pokemonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron Pokémon'),
            );
          }

          final pokemons = snapshot.data!;
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              final pokemonId =
                  pokemon.url.split('/').where((e) => e.isNotEmpty).last;

              return ListTile(
                title: Text(pokemon.name.toUpperCase()),
                subtitle: Text('ID: $pokemonId'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailScreen(pokemonId: pokemonId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
