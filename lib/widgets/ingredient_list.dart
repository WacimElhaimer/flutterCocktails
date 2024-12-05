import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final List<String?> ingredients;
  final List<String?> measures;

  const IngredientList({
    Key? key,
    required this.ingredients,
    required this.measures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(ingredients.length, (index) {
        final ingredient = ingredients[index];
        final measure = index < measures.length ? measures[index] : null;

        if (ingredient == null) return SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(
                ingredient,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (measure != null)
                Text(
                  ' - $measure',
                  style: TextStyle(color: Colors.grey[600]),
                ),
            ],
          ),
        );
      }),
    );
  }
}
