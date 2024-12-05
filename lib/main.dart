import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cocktail_provider.dart';
import 'screens/cocktail_list.dart';
import 'screens/favorites.dart';
import 'screens/cocktail_detail.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CocktailProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CocktailListScreen(),
        '/favorites': (context) => FavoritesScreen(),
        '/details': (context) => CocktailDetailScreen(),
      },
    );
  }
}
