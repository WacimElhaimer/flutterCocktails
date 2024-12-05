class Ingredient {
  final String idIngredient;
  final String strIngredient;
  final String? strDescription;
  final String? strType;
  final String? strAlcohol;
  final String? strABV;

  Ingredient({
    required this.idIngredient,
    required this.strIngredient,
    this.strDescription,
    this.strType,
    this.strAlcohol,
    this.strABV,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      idIngredient: json['idIngredient'],
      strIngredient: json['strIngredient'],
      strDescription: json['strDescription'],
      strType: json['strType'],
      strAlcohol: json['strAlcohol'],
      strABV: json['strABV'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idIngredient': idIngredient,
      'strIngredient': strIngredient,
      'strDescription': strDescription,
      'strType': strType,
      'strAlcohol': strAlcohol,
      'strABV': strABV,
    };
  }
}
