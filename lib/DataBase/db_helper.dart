import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

    Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'berries_and_pokemon.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE berries (
            id INTEGER PRIMARY KEY,
            name TEXT,
            firmness TEXT,
            growth_time INTEGER,
            max_harvest INTEGER,
            size INTEGER,
            smoothness INTEGER,
            natural_gift_type TEXT,
            natural_gift_power INTEGER,
            image_url TEXT,
            is_favorite INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE pokemons (
            id INTEGER PRIMARY KEY,
            name TEXT,
            height INTEGER,
            weight INTEGER,
            sprite_url TEXT,
            types TEXT
          )
        ''');
      },
      version: 1,
    );
  }
  // Métodos para la tabla de Pokémon
  Future<void> insertPokemon(Map<String, dynamic> pokemon) async {
    final db = await database;
    await db.insert('pokemons', pokemon, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllPokemons() async {
    final db = await database;
    return db.query('pokemons');
  }

  Future<void> deleteAllPokemons() async {
    final db = await database;
    await db.delete('pokemons');
  }
  
  

  Future<void> insertBerry(Map<String, dynamic> berry) async {
    final db = await database;
    await db.insert('berries', berry, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllBerries() async {
    final db = await database;
    return db.query('berries');
  }

  Future<List<Map<String, dynamic>>> getFavoriteBerries() async {
    final db = await database;
    return db.query('berries', where: 'is_favorite = ?', whereArgs: [1]);
  }

  Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    final db = await database;
    await db.update('berries', {'is_favorite': isFavorite}, where: 'id = ?', whereArgs: [id]);
  }
  
}
