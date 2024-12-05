import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../services/api_service.dart';

class CocktailProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Cocktail> _cocktails = [];
  List<Cocktail> _favorites = [];
  Cocktail? _selectedCocktail;
  bool _isLoading = false;
  String _errorMessage = '';

  // Nouveau état pour les sections de cocktails
  List<Map<String, dynamic>> _sectionedCocktails = [];
  List<Map<String, dynamic>> get sectionedCocktails => _sectionedCocktails;

  // Getters
  List<Cocktail> get cocktails => _cocktails;
  List<Cocktail> get favorites => _favorites;
  Cocktail? get selectedCocktail => _selectedCocktail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Recherche des cocktails par nom
  Future<void> searchCocktails(String name) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _cocktails = await _apiService.searchCocktailsByName(name);
    } catch (e) {
      _errorMessage = 'Failed to fetch cocktails: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

/// Charger les cocktails par lettre et les organiser en sections
Future<void> fetchCocktailsByLetter(String letter) async {
  if (_isLoading) return;

  try {
    _isLoading = true;

    final cocktails = await _apiService.listCocktailsByFirstLetter(letter);
    if (cocktails.isNotEmpty) {
      _sectionedCocktails.add({
        'letter': letter,
        'cocktails': cocktails,
      });
    }
  } catch (e) {
    _errorMessage = 'Failed to fetch cocktails for $letter: $e';
  } finally {
    Future.delayed(Duration.zero, () {
      _isLoading = false;
      notifyListeners();
    });
  }
}

  /// Obtenir les détails d'un cocktail
  Future<void> getCocktailDetails(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _selectedCocktail = await _apiService.getCocktailDetailsById(id);
    } catch (e) {
      _errorMessage = 'Failed to fetch cocktail details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ajouter un cocktail aux favoris
  void addToFavorites(Cocktail cocktail) {
    if (!_favorites.contains(cocktail)) {
      _favorites.add(cocktail);
      notifyListeners();
    }
  }

  /// Supprimer un cocktail des favoris
  void removeFromFavorites(Cocktail cocktail) {
    _favorites.remove(cocktail);
    notifyListeners();
  }

  /// Vérifier si un cocktail est favori
  bool isFavorite(Cocktail cocktail) {
    return _favorites.contains(cocktail);
  }

  /// Réinitialiser les sections (utile pour une nouvelle recherche ou un rafraîchissement)
  void resetSections() {
    _sectionedCocktails = [];
    notifyListeners();
  }
}
