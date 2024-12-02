import 'package:flutter/material.dart';
import 'package:pokemon_browser/DataBase/db_helper.dart';
import 'package:pokemon_browser/Screens/BerryDetailScreen.dart';
import 'package:pokemon_browser/classes/berry.dart';
import 'package:pokemon_browser/services/berryServices.dart';

class BerriesScreen extends StatefulWidget {
  const BerriesScreen({super.key});

  @override
  _BerriesScreenState createState() => _BerriesScreenState();
}

class _BerriesScreenState extends State<BerriesScreen> {
  late Future<List<Berry>> berriesFuture;
  List<Berry> _allBerries = [];
  List<Berry> _filteredBerries = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Servicio para obtener las berries
    _fetchBerries();
  }

  // Fetch berries and update the list
  Future<void> _fetchBerries() async {
    try {
      final berries = await BerryService().fetchBerries();
      setState(() {
        _allBerries = berries;
        _filteredBerries = berries; // Initially, show all berries
      });
    } catch (e) {
      print('Error fetching berries: $e');
    }
  }

  // Filter berries based on search query
  void _filterBerries(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredBerries = _allBerries;
      });
    } else {
      setState(() {
        _isSearching = true;
        _filteredBerries = _allBerries
            .where((berry) => berry.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berries'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterBerries,
              decoration: InputDecoration(
                hintText: 'Buscar Berry...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterBerries('');
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
            child: _filteredBerries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredBerries.length,
                    itemBuilder: (context, index) {
                      final berry = _filteredBerries[index];
                      final berryId = berry.url.split('/').where((e) => e.isNotEmpty).last;
                      final spriteUrl =
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/berries/${berry.name.toLowerCase()}-berry.png";

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
                          title: Text(berry.name.toUpperCase()),
                          subtitle: Text('ID: $berryId'),
                          trailing: IconButton(
                            icon: Icon(
                              berry.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: berry.isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              final isCurrentlyFavorite = berry.isFavorite;

                              try {
                                await DBHelper().updateFavoriteStatus(
                                  int.parse(berryId),
                                  isCurrentlyFavorite ? 0 : 1,
                                );

                                setState(() {
                                  berry.isFavorite = !isCurrentlyFavorite;
                                });
                              } catch (e) {
                                print('Error al actualizar el estado favorito: $e');
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BerryDetailScreen(berryId: berryId),
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
