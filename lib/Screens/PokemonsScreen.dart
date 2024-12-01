import 'package:flutter/material.dart';
import 'package:pokemon_browser/classes/pokemon.dart';
import 'package:pokemon_browser/services/pokeServices.dart';
import 'package:pokemon_browser/DataBase/db_helper.dart'; // Asegúrate de importar tu DBHelper
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
    // Servicio para obtener la lista de Pokémon
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

              return Card(
                child: ListTile(
                  title: Text(pokemon.name.toUpperCase()),
                  subtitle: Text('ID: $pokemonId'),
                  trailing: IconButton(
                    icon: Icon(
                      pokemon.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: pokemon.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      // Primero guardamos el estado anterior para no tener problemas si falla la DB
                      final isCurrentlyFavorite = pokemon.isFavorite;

                      // Actualizamos el estado localmente primero para que la UI cambie inmediatamente
                      setState(() {
                        pokemon.isFavorite = !isCurrentlyFavorite;
                      });

                      // Luego intentamos actualizar el estado en la base de datos
                      try {
                        await DBHelper().updatePokemonFavoriteStatus(
                          int.parse(pokemonId),
                          isCurrentlyFavorite ? 0 : 1,
                        );
                      } catch (e) {
                        // Si ocurre un error, revertimos el cambio en el estado
                        setState(() {
                          pokemon.isFavorite = !isCurrentlyFavorite;
                        });
                        print('Error al actualizar el estado de favorito: $e');
                      }
                    },
                  ),
                  onTap: () {
                    // Navegar a la pantalla de detalles al seleccionar un Pokémon
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PokemonDetailScreen(pokemonId: pokemonId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
