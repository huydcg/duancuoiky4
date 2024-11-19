import 'package:firebase_database/firebase_database.dart';

class RecipeService2 {
  final DatabaseReference dbRef2 = FirebaseDatabase.instance.ref("monan");

  // Function to edit a recipe by its ID
  Future<void> editRecipe(
      String recipeId, Map<String, dynamic> updatedData) async {
    DatabaseReference recipeRef = dbRef2.child(recipeId);
    await recipeRef.update(updatedData);
  }
}
