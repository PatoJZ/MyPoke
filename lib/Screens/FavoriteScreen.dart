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
    // Cargar favoritos desde la base de datos
    final berries = await DBHelper().getFavoriteBerries();
    final pokemons = await DBHelper().getFavoritePokemons();

    // Actualizar el estado para mostrar los resultados
    setState(() {
      favoriteBerries = berries;
      favoritePokemons = pokemons;
    });
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
                ? const Center(child: Text('No tienes berries favoritas.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: favoriteBerries.length,
                    itemBuilder: (context, index) {
                      final berry = favoriteBerries[index];
                      return ListTile(
                        title: Text(berry['name'].toUpperCase()),
                        subtitle: Text('ID: ${berry['id']}'),
                      );
                    },
                  ),
            const Divider(),

            // Sección de Pokémons favoritos
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pokémones Favoritos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            favoritePokemons.isEmpty
                ? const Center(child: Text('No tienes pokémones favoritos.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: favoritePokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = favoritePokemons[index];
                      return ListTile(
                        title: Text(pokemon['name'].toUpperCase()),
                        subtitle: Text('ID: ${pokemon['id']}'),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
