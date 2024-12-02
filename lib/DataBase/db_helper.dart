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
            types TEXT,
            is_favorite INTEGER DEFAULT 0
          )
        ''');

      },
      version: 3,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          var result = await db.rawQuery('PRAGMA table_info(pokemons)');
          bool columnExists = result.any((column) => column['name'] == 'is_favorite');
          
          if (!columnExists) {
            await db.execute('ALTER TABLE pokemons ADD COLUMN is_favorite INTEGER DEFAULT 0');
          }
        }
      },
    );
  }

  Future<void> debugCheckTables() async {
    final db = await database;

    final pokemonCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM pokemons'));
    final berryCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM berries'));

    print('Total Pokémon en la base de datos: $pokemonCount');
    print('Total Berries en la base de datos: $berryCount');
  }

  Future<void> insertPokemon(Map<String, dynamic> pokemon) async {
    final db = await database;
    await db.insert('pokemons', pokemon, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<void> insertBerry(Map<String, dynamic> berry) async {
    final db = await database;
    await db.insert('berries', berry, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<int> isPokemonFavorite(int id) async {
    final db = await database;
    final result = await db.query(
      'pokemons',
      columns: ['is_favorite'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['is_favorite'] as int;
    }
    return 0;
  }


  Future<int> isBerryFavorite(int id) async {
    final db = await database;
    final result = await db.query(
      'berries',
      columns: ['is_favorite'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['is_favorite'] as int;
    }
    return 0;
  }

  Future<int> getPokemonFavoriteStatus(int id) async {
    final db = await database;
    final result = await db.query(
      'pokemons',
      columns: ['is_favorite'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['is_favorite'] as int;
    }
    return 0;
  }


  Future<int> getFavoriteStatus(String table, int id) async {
    final db = await database;
    final result = await db.query(
      table,
      columns: ['is_favorite'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['is_favorite'] as int;
    }
    return 0;
  }


  Future<void> togglePokemonFavorite(
    int id,
    bool isFavorite,
    String name,
    String spriteUrl,
  ) async {
    final db = await database;

 
    final result = await db.query(
      'pokemons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {

      await db.update(
        'pokemons',
        {'is_favorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {

      await db.insert(
        'pokemons',
        {
          'id': id,
          'name': name,
          'sprite_url': spriteUrl,
          'is_favorite': isFavorite ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<void> toggleBerryFavorite(
    int id,
    bool isFavorite,
    String name,
    String imageUrl,
  ) async {
    final db = await database;


    final result = await db.query(
      'berries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {

      await db.update(
        'berries',
        {'is_favorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
   
      await db.insert(
        'berries',
        {
          'id': id,
          'name': name,
          'image_url': imageUrl,
          'is_favorite': isFavorite ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  
  Future<List<Map<String, dynamic>>> getAllPokemons() async {
    final db = await database;
    return db.query('pokemons');
  }

  Future<List<Map<String, dynamic>>> getAllBerries() async {
    final db = await database;
    return db.query('berries');
  }

  Future<List<Map<String, dynamic>>> getFavoritePokemons() async {
    final db = await database;
    return db.query('pokemons', where: 'is_favorite = ?', whereArgs: [1]);
  }

  Future<List<Map<String, dynamic>>> getFavoriteBerries() async {
    final db = await database;
    return db.query('berries', where: 'is_favorite = ?', whereArgs: [1]);
  }

  Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    final db = await database;
    await db.update('berries', {'is_favorite': isFavorite},
        where: 'id = ?', whereArgs: [id]);
  }
}
