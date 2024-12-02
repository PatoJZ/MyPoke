import 'package:flutter/material.dart';
import 'package:pokemon_browser/classes/pokemon.dart';
import 'package:pokemon_browser/services/pokeServices.dart';
import 'package:pokemon_browser/DataBase/db_helper.dart';
import 'PokemonDetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonsScreen extends StatefulWidget {
  const PokemonsScreen({Key? key}) : super(key: key);

  @override
  _PokemonsScreenState createState() => _PokemonsScreenState();
}

class _PokemonsScreenState extends State<PokemonsScreen> {
  final PokemonService _pokemonService = PokemonService();
  List<Pokemon> _pokemons = [];
  List<Pokemon> _filteredPokemons = [];
  bool _isLoading = false;
  bool _isSearching = false;
  int _offset = 0;
  final int _limit = 20;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
    DBHelper().debugCheckTables();  // Verificar las tablas
  }

  Future<void> _fetchPokemons() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newPokemons = await _pokemonService.fetchPokemons(
        limit: _limit,
        offset: _offset,
      );

      // Verificamos el estado de favoritos desde la base de datos
      for (var pokemon in newPokemons) {
        final pokemonId =
            pokemon.url.split('/').where((e) => e.isNotEmpty).last; // Extraer el ID desde la URL
        final isFavorite = await DBHelper().isPokemonFavorite(int.parse(pokemonId));
        pokemon.isFavorite = isFavorite == 1;
      }

      setState(() {
        _pokemons.addAll(newPokemons);
        _filteredPokemons = _pokemons; // Inicialmente, todos los Pokémon están visibles
        _offset += _limit;
      });
    } catch (e) {
      print('Error fetching pokemons: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 && !_isLoading) {
      _fetchPokemons();
    }
  }

  void _filterPokemons(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredPokemons = _pokemons;
      });
    } else {
      setState(() {
        _isSearching = true;
        _filteredPokemons = _pokemons
            .where((pokemon) =>
                pokemon.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémons'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPokemons,
              decoration: InputDecoration(
                hintText: 'Buscar Pokémon...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterPokemons('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _isLoading && _pokemons.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _filteredPokemons.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _filteredPokemons.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final pokemon = _filteredPokemons[index];
                      final pokemonId = pokemon.url
                          .split('/')
                          .where((e) => e.isNotEmpty)
                          .last;
                      final spriteUrl =
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';

                      return Card(
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: spriteUrl,
                            width: 50,
                            height: 50,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_not_supported),
                          ),
                          title: Text(pokemon.name.toUpperCase()),
                          subtitle: Text('Dex num: $pokemonId'),
                          trailing: IconButton(
                            icon: Icon(
                              pokemon.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: pokemon.isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              final isCurrentlyFavorite = pokemon.isFavorite;
                              setState(() {
                                pokemon.isFavorite = !isCurrentlyFavorite;
                              });

                              try {
                                await DBHelper().updatePokemonFavoriteStatus(
                                  int.parse(pokemonId),
                                  isCurrentlyFavorite ? 0 : 1,
                                );
                              } catch (e) {
                                setState(() {
                                  pokemon.isFavorite = !isCurrentlyFavorite;
                                });
                                print('Error al actualizar favorito: $e');
                              }
                            },
                          ),
                          onTap: () {
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
                  ),
          ),
        ],
      ),
    );
  }
}
