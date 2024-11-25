import 'package:flutter/material.dart';

class PokemonsScreen extends StatefulWidget {
  const PokemonsScreen({super.key});

  @override
  _PokemonsScreenState createState() => _PokemonsScreenState();
}

class _PokemonsScreenState extends State<PokemonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemones'),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán los Pokemones',
        ),
      ),
    );
  }
}
