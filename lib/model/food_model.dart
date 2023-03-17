class FoodRecipe{
  final String food_id;
  final String name;
  final List<Map> recipe;
  final String description;

  const FoodRecipe({
    required this.food_id,
    required this.name,
    required this.recipe,
    required this.description,
    
  });
}