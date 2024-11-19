import 'package:duancuoiky/widgets/SuamonanD.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuaMonAn extends StatefulWidget {
  const SuaMonAn({super.key});

  @override
  _SuaMonAnState createState() => _SuaMonAnState();
}

class _SuaMonAnState extends State<SuaMonAn> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  // Function to load recipe list from Firebase
  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    if (username.isEmpty) return;

    final snapshot =
        await dbRef.orderByChild('username').equalTo(username).once();
    final data = snapshot.snapshot.value as Map?;

    if (data != null) {
      List<Map<String, dynamic>> tempRecipes = [];
      data.forEach((key, value) {
        tempRecipes.add({
          'key': key,
          'tenMonAn': value['tenMonAn'] ?? '',
          'username': value['username'] ?? '',
        });
      });

      setState(() {
        recipes = tempRecipes;
      });
    }
  }

  // Function to delete a recipe by its key
  Future<void> _deleteRecipe(String key) async {
    await dbRef.child(key).remove();
    // Remove the deleted recipe directly from the local list to reflect changes immediately
    setState(() {
      recipes.removeWhere((recipe) => recipe['key'] == key);
    });
  }

  // Function to show the edit screen for a recipe
  void _editRecipe(String key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuaCongThucm(recipeId: key),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chủ')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Món Ăn',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Display the list of recipe names with edit and delete buttons
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipe['tenMonAn'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editRecipe(recipe['key']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteRecipe(recipe['key']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
