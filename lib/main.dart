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
        colorScheme: const ColorScheme(
          primary: Color(0xFFD32F2F), // Rojo Suave
          primaryContainer: Color(0xFFB71C1C),
          secondary: Color(0xFFFBC02D),
          secondaryContainer: Color(0xFFF57F17),
          surface: Color(0xFFFFFFFF),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFF5C6BC0),
          onSurface: Color(0xFF37474F),
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD32F2F),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBC02D),
            foregroundColor: const Color(0xFF5C6BC0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Color(0xFFD32F2F)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD32F2F)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD32F2F)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: NavigationScreen(),
    );
  }
}
