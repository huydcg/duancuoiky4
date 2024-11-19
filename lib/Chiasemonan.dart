import 'package:duancuoiky/widgets/SuamonanWidget.dart';
import 'package:duancuoiky/widgets/ThemmonanWidget.dart';
import 'package:duancuoiky/widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chiasemonan extends StatefulWidget {
  const Chiasemonan({super.key});

  @override
  _ChiasemonanState createState() => _ChiasemonanState();
}

class _ChiasemonanState extends State<Chiasemonan> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Load data from Firebase on initialization
  }

  // Function to load recipe list from Firebase
  Future<void> _loadRecipes() async {
    // final snapshot = await dbRef.once();
    // final data = snapshot.snapshot.value as Map?;

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    final snapshot =
        await dbRef.orderByChild('username').equalTo(username).once();
    final data = snapshot.snapshot.value as Map?;

    if (username.isEmpty) return;

    if (data != null) {
      List<Map<String, dynamic>> tempRecipes = [];
      data.forEach((key, value) {
        tempRecipes.add({
          'key': key,
          'tenMonAn': value['tenMonAn'] ?? '',
          'thanhPhan': value['thanhPhan'] ?? '',
          'huongDan': value['huongDan'] ?? '',
          'imageFileName': value['imageFileName'] ?? '',
          'theloai': value['theloai'] ?? '',
          'mucdo': value['mucdo'] ?? '',
          'username': value['username'] ?? '',
        });
      });

      setState(() {
        recipes = tempRecipes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chủ')),
      body: ListView(
        children: [
          // Display recipes in a Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title for recipe section
                const Text(
                  'Món Ăn',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Recipe Row (Horizontal Scroll)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: recipes.map((recipe) {
                      String imageUrl = recipe['imageFileName'];

                      if (imageUrl.isEmpty) {
                        imageUrl = 'images/xao.png';
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          width: 150, // Adjust width for horizontal layout
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recipe Image
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: imageUrl.startsWith('http')
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              // Recipe Name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  recipe['tenMonAn'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Recipe Category
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Thể Loại: ${recipe['theloai']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Difficulty Level and Favorite Icon
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mức Độ: ${recipe['mucdo']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 17,
                                    )
                                  ],
                                ),
                              ),
                              //

                              //
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Them
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                // Open the add recipe dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ThemCongThucm(); // Open add recipe dialog
                  },
                );
              },
              child: const Text('Thêm'),
            ),
          ),

          //Sua
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                // Open the add recipe dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return const SuaMonAn(); // Open add recipe dialog
                  },
                );
              },
              child: const Text('Sửa'),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
    );
  }
}
