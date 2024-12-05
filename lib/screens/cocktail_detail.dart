import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cocktail_provider.dart';

class CocktailDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CocktailProvider>(context);
    final cocktail = provider.selectedCocktail;

    if (cocktail == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Cocktail Details')),
        body: Center(child: Text('No details available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.strDrink),
        actions: [
          IconButton(
            icon: Icon(
              provider.isFavorite(cocktail)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () {
              if (provider.isFavorite(cocktail)) {
                provider.removeFromFavorites(cocktail);
              } else {
                provider.addToFavorites(cocktail);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                cocktail.strDrinkThumb ?? '',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Category: ${cocktail.strCategory ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Alcoholic: ${cocktail.strAlcoholic ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(cocktail.strInstructions ?? 'No instructions available'),
            SizedBox(height: 16),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...cocktail.ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;
              final measure =
                  index < cocktail.measures.length ? cocktail.measures[index] : '';
              return Text('${ingredient ?? ''}: ${measure ?? ''}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
