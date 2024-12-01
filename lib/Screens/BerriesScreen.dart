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

  @override
  void initState() {
    super.initState();
    // servicio para obtener las berries
    berriesFuture = BerryService().fetchBerries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berries'),
      ),
      body: FutureBuilder<List<Berry>>(
        // Asignar lista de berries
        future: berriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron berries'),
            );
          }

          final berries = snapshot.data!;
          return ListView.builder(
            itemCount: berries.length,
            itemBuilder: (context, index) {
              final berry = berries[index];
              final berryId =
                  berry.url.split('/').where((e) => e.isNotEmpty).last;
              return Card(
                child: ListTile(
                  title: Text(berry.name.toUpperCase()),
                  subtitle: Text('ID: $berryId'),
                  trailing: IconButton(
                    icon: Icon(
                      berry.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: berry.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      // Mostrar un indicador de progreso opcional o desactivar temporalmente la interacción del usuario
                      final isCurrentlyFavorite = berry.isFavorite;

                      // Actualizar el estado de favorito después de la operación asíncrona
                      try {
                        // Actualiza la base de datos antes de cambiar el estado
                        await DBHelper().updateFavoriteStatus(
                          int.parse(berryId),
                          isCurrentlyFavorite ? 0 : 1,
                        );

                        // Si la operación fue exitosa, cambia el estado localmente
                        setState(() {
                          berry.isFavorite = !isCurrentlyFavorite;
                        });
                      } catch (e) {
                        // Manejar el error aquí si la operación falla
                        print('Error al actualizar el estado favorito: $e');
                      }
                    },
                  ),
                  onTap: () {
                    // Navegar a la pantalla de detalles al seleccionar una berry
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BerryDetailScreen(berryId: berryId),
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
