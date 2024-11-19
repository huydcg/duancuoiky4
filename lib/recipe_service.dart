import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");
  final DatabaseReference dbRef2 = FirebaseDatabase.instance.ref("nuocuong");
  final DatabaseReference favoriteRef =
      FirebaseDatabase.instance.ref("yeuthich");

  // Load
  Future<List<Map<String, dynamic>>> loadUserRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    if (username.isEmpty) return [];

    final snapshot =
        await dbRef.orderByChild('username').equalTo(username).once();
    final data = snapshot.snapshot.value as Map?;

    List<Map<String, dynamic>> recipes = [];
    if (data != null) {
      data.forEach((key, value) {
        recipes.add({
          'key': key,
          ...value as Map<String, dynamic>,
        });
      });
    }

    return recipes;
  }

  // Lưu món ăn/nước yêu thích
  Future<void> saveFavoriteRecipe(String Id, String category) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    if (username.isNotEmpty) {
      final favoriteData = {
        'Id': Id,
        'username': username,
        'category': category, // Để phân biệt là món ăn hay nước uống
      };

      // Lưu vào Firebase (chia theo món ăn và nước uống)
      await favoriteRef.push().set(favoriteData);
    }
  }

  // Delete by ID
  Future<void> deleteRecipe(String Id) async {
    await dbRef.child(Id).remove();
  }

  edit(String Id, Map<String, String> map) {}
}
