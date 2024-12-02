import 'package:flutter/material.dart';
import 'package:pokemon_browser/DataBase/db_helper.dart';
import 'package:pokemon_browser/Screens/NavigationScreen.dart';
import 'package:pokemon_browser/services/berryServices.dart';
import 'package:pokemon_browser/services/pokeServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(MyApp());
}

Future<void> initializeDatabase() async {
  final dbHelper = DBHelper();
  final berryService = BerryService();
  final pokemonService = PokemonService();

  // Verifica y guarda las berries
  final existingBerries = await dbHelper.getAllBerries();
  if (existingBerries.isEmpty) {
    try {
      final berries = await berryService.fetchBerries();
      for (var berry in berries) {
        final berryDetail = await berryService.fetchBerryDetail(berry.id.toString());
        await dbHelper.insertBerry({
          'id': berry.id, // Usando el getter `id`
          'name': berry.name,
          'firmness': berryDetail.firmness,
          'growth_time': berryDetail.growthTime,
          'max_harvest': berryDetail.maxHarvest,
          'size': berryDetail.size,
          'smoothness': berryDetail.smoothness,
          'natural_gift_type': berryDetail.naturalGiftType,
          'natural_gift_power': berryDetail.naturalGiftPower,
          'image_url': 'https://pokeapi.co/sprites/items/${berryDetail.name}.png',
          'is_favorite': 0,
        });
      }
    } catch (e) {
      print('Error loading berries: $e');
    }
  }

  // Verifica y guarda los Pokémon
  final existingPokemons = await dbHelper.getAllPokemons();
  if (existingPokemons.isEmpty) {
    try {
      final pokemons = await pokemonService.fetchPokemons();
      for (var pokemon in pokemons) {
        await dbHelper.insertPokemon({
          'id': pokemon.id, // Usando el getter `id`
          'name': pokemon.name,
          'sprite_url': pokemon.url, // Puedes reemplazar con un detalle más específico si tienes otra API
          'is_favorite': 0,
        });
      }
    } catch (e) {
      print('Error loading Pokémon: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(
        fontFamily: "baloo",

        useMaterial3: true,
        // Define un esquema de colores suavizados
        colorScheme: const ColorScheme(
          primary: Color(0xFFD32F2F), // Rojo Suave
          primaryContainer: Color(0xFFB71C1C), // Tonalidad más oscura
          secondary: Color(0xFFFBC02D), // Amarillo Suave
          secondaryContainer: Color(0xFFF57F17), // Blanco Crema
          surface: Color(0xFFFFFFFF), // Fondo de componentes
          onPrimary: Color(0xFFFFFFFF), // Texto sobre color primario (Blanco)
          onSecondary: Color(0xFF5C6BC0), // Texto sobre fondo (Gris Oscuro)
          onSurface: Color(0xFF37474F), // Texto sobre superficies (Gris Oscuro)
          error: Colors.red, // Color de error
          onError: Colors.white, // Texto sobre error
          brightness: Brightness.light, // Tema claro
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Fondo de la app
        // Tema del AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD32F2F), // Fondo rojo suave
          foregroundColor: Color(0xFFFFFFFF), // Texto blanco
          elevation: 0, // Sin sombra
          centerTitle: true,
        ),
        // Tema para los botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBC02D), // Fondo amarillo suave
            foregroundColor: const Color(0xFF5C6BC0), // Texto azul suave
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
          ),
        ),
        // Tema del BottomNavigationBar
        
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFD32F2F), // Ícono seleccionado rojo suave
        
          unselectedItemColor:
              Color(0xFF5C6BC0), // Ícono no seleccionado azul suave
          backgroundColor: Color(0xFFFBC02D), // Fondo amarillo suave
        ),
      ),
      home: const NavigationScreen(),
    );
  }
}
