import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cocktail_provider.dart';
import 'cocktail_detail.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CocktailProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: provider.favorites.isEmpty
          ? Center(
              child: Text('No favorites yet'),
            )
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final cocktail = provider.favorites[index];
                return ListTile(
                  leading: cocktail.strDrinkThumb != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            cocktail.strDrinkThumb!,
                          ),
                        )
                      : CircleAvatar(
                          child: Icon(Icons.local_drink),
                        ),
                  title: Text(cocktail.strDrink),
                  subtitle: Text(cocktail.strCategory ?? ''),
                  onTap: () {
                    provider.getCocktailDetails(cocktail.idDrink);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CocktailDetailScreen(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
