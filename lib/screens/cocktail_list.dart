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
  final List<String> _alphabet = List.generate(26, (i) => String.fromCharCode(65 + i)); // A à Z

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
    final provider = Provider.of<CocktailProvider>(context, listen: false);

    if (_scrollController.position.pixels == 
            _scrollController.position.maxScrollExtent &&
        !provider.isLoading) {
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
    Consumer<CocktailProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => Navigator.pushNamed(context, '/favorites'),
            ),
            if (provider.favorites.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    provider.favorites.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  ],
),

      body: Row(
        children: [
          // Liste des cocktails à gauche
          Expanded(
            child: Column(
              children: [
                // Barre de recherche
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
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.sectionedCocktails.length + 1,
                    itemBuilder: (context, index) {
                      if (index == provider.sectionedCocktails.length) {
                        return provider.isLoading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox.shrink(); // Rien à afficher
                      }

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
                                      provider.getCocktailDetails(cocktail.idDrink);
                                      Navigator.pushNamed(context, '/details');
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
          ),
          // Liste alphabétique à droite
          Container(
            width: 50,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _alphabet.length,
              itemBuilder: (context, index) {
                final letter = _alphabet[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentLetter = letter;
                    });
                    _fetchCocktails();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: _currentLetter == letter
                        ? Colors.blue[200]
                        : Colors.transparent,
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _currentLetter == letter
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
