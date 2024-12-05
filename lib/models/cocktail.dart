class Cocktail {
  final String idDrink;
  final String strDrink;
  final String? strTags;
  final String? strCategory;
  final String? strIBA;
  final String? strAlcoholic;
  final String? strGlass;
  final String? strInstructions;
  final String? strDrinkThumb;
  final List<String?> ingredients;
  final List<String?> measures;

  Cocktail({
    required this.idDrink,
    required this.strDrink,
    this.strTags,
    this.strCategory,
    this.strIBA,
    this.strAlcoholic,
    this.strGlass,
    this.strInstructions,
    this.strDrinkThumb,
    required this.ingredients,
    required this.measures,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    // Récupérer les ingrédients et les mesures
    List<String?> ingredients = [];
    List<String?> measures = [];
    for (int i = 1; i <= 15; i++) {
      ingredients.add(json['strIngredient$i']);
      measures.add(json['strMeasure$i']);
    }

    return Cocktail(
      idDrink: json['idDrink'],
      strDrink: json['strDrink'],
      strTags: json['strTags'],
      strCategory: json['strCategory'],
      strIBA: json['strIBA'],
      strAlcoholic: json['strAlcoholic'],
      strGlass: json['strGlass'],
      strInstructions: json['strInstructions'],
      strDrinkThumb: json['strDrinkThumb'],
      ingredients: ingredients.where((item) => item != null).toList(),
      measures: measures.where((item) => item != null).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['idDrink'] = idDrink;
    data['strDrink'] = strDrink;
    data['strTags'] = strTags;
    data['strCategory'] = strCategory;
    data['strIBA'] = strIBA;
    data['strAlcoholic'] = strAlcoholic;
    data['strGlass'] = strGlass;
    data['strInstructions'] = strInstructions;
    data['strDrinkThumb'] = strDrinkThumb;

    // Ajouter les ingrédients et mesures
    for (int i = 0; i < ingredients.length; i++) {
      data['strIngredient${i + 1}'] = ingredients[i];
    }
    for (int i = 0; i < measures.length; i++) {
      data['strMeasure${i + 1}'] = measures[i];
    }

    return data;
  }
}
