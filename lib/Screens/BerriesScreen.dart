import 'package:flutter/material.dart';
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
              return ListTile(
                title: Text(berry.name.toUpperCase()),
                subtitle: Text('ID: $berryId'),
                onTap: () {
                  // Navegar a la pantalla de detalles al seleccionar una berry
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BerryDetailScreen(berryId: berryId),
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
