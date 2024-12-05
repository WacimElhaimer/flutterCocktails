import 'package:flutter/material.dart';
import '../models/cocktail.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;
  final VoidCallback onTap;

  const CocktailCard({
    Key? key,
    required this.cocktail,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: ListTile(
        leading: cocktail.strDrinkThumb != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  cocktail.strDrinkThumb!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : CircleAvatar(child: Icon(Icons.local_drink)),
        title: Text(
          cocktail.strDrink,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(cocktail.strCategory ?? 'Unknown category'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
