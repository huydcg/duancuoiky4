import 'package:duancuoiky/widgets/Chitietm.dart';
import 'package:duancuoiky/widgets/Chitietn.dart';
import 'package:duancuoiky/widgets/DrawerWidgeta.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Trangchua extends StatefulWidget {
  const Trangchua({super.key});

  @override
  _TrangchuaStatea createState() => _TrangchuaStatea();
}

class _TrangchuaStatea extends State<Trangchua> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");
  final DatabaseReference dbRef2 = FirebaseDatabase.instance.ref("nuocuong");
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> drinks = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _loadDrinks();
  }

  // Function to load recipe list from Firebase
  Future<void> _loadRecipes() async {
    final snapshot = await dbRef.once();
    final data = snapshot.snapshot.value as Map?;

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
        });
      });

      setState(() {
        recipes = tempRecipes;
      });
    }
  }

  // Load drinks from Firebase
  Future<void> _loadDrinks() async {
    final snapshot = await dbRef2.once();
    final data = snapshot.snapshot.value as Map?;

    if (data != null) {
      List<Map<String, dynamic>> tempDrinks = [];
      data.forEach((key, value) {
        tempDrinks.add({
          'key': key,
          'ten_nuoc': value['ten_nuoc'] ?? '',
          'thanh_phan': value['thanh_phan'] ?? '',
          'huong_dan': value['huong_dan'] ?? '',
          'imageFileName': value['imageFileName'] ?? '',
          'the_loai': value['the_loai'] ?? '',
          'muc_do': value['muc_do'] ?? '',
        });
      });

      setState(() {
        drinks = tempDrinks;
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Chitietmonan(dishId: recipe['key']),
                                      ),
                                    );
                                  },
                                  child: const Text('Chi tiết'),
                                ),
                              ),
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
          //

          //
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nước Uống',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Drinks Row (Horizontal Scroll)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: drinks.map((drink) {
                      String imageUrl = drink['imageFileName'];

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
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  drink['ten_nuoc'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Thể Loại: ${drink['the_loai']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mức Độ: ${drink['muc_do']}",
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Chitietnuocuong(
                                            dishId: drink['key']),
                                      ),
                                    );
                                  },
                                  child: const Text('Chi tiết'),
                                ),
                              ),
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
          //
        ],
      ),
      drawer: const DrawerWidgeta(),
    );
  }
}
