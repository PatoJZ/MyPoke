import 'package:flutter/material.dart';
import 'package:pokemon_browser/DataBase/db_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> favoriteBerries = [];
  List<Map<String, dynamic>> favoritePokemons = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
  
    final berries = await DBHelper().getFavoriteBerries();
    final pokemons = await DBHelper().getFavoritePokemons();

 
    setState(() {
      favoriteBerries = berries;
      favoritePokemons = pokemons;
    });
  }

  Future<void> _toggleFavoriteBerry(int berryId, bool isCurrentlyFavorite) async {
    try {
      await DBHelper().toggleBerryFavorite(
        berryId,
        isCurrentlyFavorite ? false : true,
        "Berry Name", 
        "Berry Image URL" 
      );
      _loadFavorites(); 
    } catch (e) {
      print('Error al actualizar el estado favorito: $e');
    }
  }

  Future<void> _toggleFavoritePokemon(int pokemonId, bool isCurrentlyFavorite) async {
    try {
      await DBHelper().togglePokemonFavorite(
        pokemonId,
        isCurrentlyFavorite ? false : true,
        "Pokemon Name", 
        "Pokemon Sprite URL" 
      );
      _loadFavorites(); 
    } catch (e) {
      print('Error al actualizar el estado favorito: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Berries favoritas
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Berries Favoritas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            favoriteBerries.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No tienes berries favoritas.'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoriteBerries.length,
                    itemBuilder: (context, index) {
                      final berry = favoriteBerries[index];
                      final berryId = berry['id'];
                      final spriteUrl =
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/berries/${berry['name'].toLowerCase()}-berry.png";

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            spriteUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 50);
                            },
                          ),
                          title: Text(berry['name'].toUpperCase()),
                          subtitle: Text('ID: $berryId'),
                          trailing: IconButton(
                            icon: Icon(
                              berry['is_favorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                              color: berry['is_favorite'] == 1 ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              await _toggleFavoriteBerry(berryId, berry['is_favorite'] == 1);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            const Divider(),

            // Sección de Pokémones favoritos
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pokémones Favoritos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            favoritePokemons.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No tienes pokémones favoritas.'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoritePokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = favoritePokemons[index];
                      final pokemonId = pokemon['id'];
                      final spriteUrl =
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            spriteUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 50);
                            },
                          ),
                          title: Text(pokemon['name'].toUpperCase()),
                          subtitle: Text('ID: $pokemonId'),
                          trailing: IconButton(
                            icon: Icon(
                              pokemon['is_favorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                              color: pokemon['is_favorite'] == 1 ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              await _toggleFavoritePokemon(pokemonId, pokemon['is_favorite'] == 1);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
