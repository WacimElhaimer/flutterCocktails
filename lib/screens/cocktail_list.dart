import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cocktail_provider.dart';
import 'cocktail_detail.dart';

class CocktailListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CocktailProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktails'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Cocktails',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                provider.searchCocktails(value);
              },
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                    ? Center(child: Text(provider.errorMessage))
                    : ListView.builder(
                        itemCount: provider.cocktails.length,
                        itemBuilder: (context, index) {
                          final cocktail = provider.cocktails[index];
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
                                  builder: (context) =>
                                      CocktailDetailScreen(),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
