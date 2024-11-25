import 'package:flutter/material.dart';
import 'package:pokemon_browser/Screens/NavigationScreen.dart';

void main() {
  runApp(MyApp());
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
