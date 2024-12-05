import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cocktail_provider.dart';
import '../widgets/cocktail_card.dart';

class CocktailListScreen extends StatefulWidget {
  @override
  _CocktailListScreenState createState() => _CocktailListScreenState();
}

class _CocktailListScreenState extends State<CocktailListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentLetter = 'A'; // Commence par la lettre A

  @override
  void initState() {
    super.initState();
    _fetchCocktails(); // Charger la première lettre
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchCocktails() {
    final provider = Provider.of<CocktailProvider>(context, listen: false);
    provider.fetchCocktailsByLetter(_currentLetter);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Charger la lettre suivante
      final nextLetter = String.fromCharCode(_currentLetter.codeUnitAt(0) + 1);
      if (nextLetter.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) {
        setState(() {
          _currentLetter = nextLetter;
        });
        _fetchCocktails();
      }
    }
  }

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
          // SearchBar
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
          // Liste des cocktails avec sections
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.sectionedCocktails.isEmpty
                    ? Center(child: Text('No cocktails found'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.sectionedCocktails.length,
                        itemBuilder: (context, index) {
                          final section = provider.sectionedCocktails[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // En-tête de section (lettre)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  section['letter'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Liste des cocktails dans la section
                              ...section['cocktails']
                                  .map<Widget>((cocktail) => CocktailCard(
                                        cocktail: cocktail,
                                        onTap: () {
                                          provider.getCocktailDetails(
                                              cocktail.idDrink);
                                          Navigator.pushNamed(
                                              context, '/details');
                                        },
                                      ))
                                  .toList(),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
