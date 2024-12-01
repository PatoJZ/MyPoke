import 'package:flutter/material.dart';
import 'package:pokemon_browser/Screens/BerriesScreen.dart';
import 'package:pokemon_browser/Screens/HomeScreen.dart';
import 'package:pokemon_browser/Screens/FavoriteScreen.dart';
import 'package:pokemon_browser/Screens/PokemonsScreen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    //const HomeScreen(),
    const BerriesScreen(),
    const PokemonsScreen(),
    const FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          // BottomNavigationBarItem(
          //  icon: Icon(Icons.house),
          //  label: 'Home',
          //),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: 'berries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pokemones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
