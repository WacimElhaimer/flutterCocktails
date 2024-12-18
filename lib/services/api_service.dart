import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail.dart';
import '../models/ingredient.dart';

class ApiService {
  static const String _baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1';

  /// Rechercher des cocktails par nom
  Future<List<Cocktail>> searchCocktailsByName(String name) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['drinks'] != null) {
        return (data['drinks'] as List)
            .map((drink) => Cocktail.fromJson(drink))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  /// Lister les cocktails par première lettre
  Future<List<Cocktail>> listCocktailsByFirstLetter(String letter) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?f=$letter'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['drinks'] != null) {
        return (data['drinks'] as List)
            .map((drink) => Cocktail.fromJson(drink))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  /// Détails complets d'un cocktail par ID
  Future<Cocktail?> getCocktailDetailsById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['drinks'] != null && data['drinks'].isNotEmpty) {
        return Cocktail.fromJson(data['drinks'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to load cocktail details');
    }
  }

  /// Rechercher des cocktails par ingrédient
  Future<List<Cocktail>> searchCocktailsByIngredient(String ingredient) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/filter.php?i=$ingredient'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['drinks'] != null) {
        return (data['drinks'] as List)
            .map((drink) => Cocktail.fromJson(drink))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load cocktails by ingredient');
    }
  }

  /// Obtenir un cocktail aléatoire
  Future<Cocktail?> getRandomCocktail() async {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['drinks'] != null && data['drinks'].isNotEmpty) {
        return Cocktail.fromJson(data['drinks'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to load random cocktail');
    }
  }

  /// Obtenir les détails d'un ingrédient par ID
  Future<Ingredient?> getIngredientById(String id) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/lookup.php?iid=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['ingredients'] != null && data['ingredients'].isNotEmpty) {
        return Ingredient.fromJson(data['ingredients'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to load ingredient details');
    }
  }

  /// Rechercher un ingrédient par nom
  Future<Ingredient?> searchIngredientByName(String name) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/search.php?i=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['ingredients'] != null && data['ingredients'].isNotEmpty) {
        return Ingredient.fromJson(data['ingredients'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to search ingredient by name');
    }
  }

  /// Lister les catégories, verres, ingrédients ou types d'alcool
  Future<List<String>> listFilterOptions(String filter) async {
    final response = await http.get(Uri.parse('$_baseUrl/list.php?$filter=list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['drinks'] != null) {
        return (data['drinks'] as List)
            .map((item) => item['str$filter'] as String)
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load filter options');
    }
  }
}
