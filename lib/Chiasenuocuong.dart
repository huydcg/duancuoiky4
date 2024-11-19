import 'package:duancuoiky/widgets/DrawerWidget.dart';
import 'package:duancuoiky/widgets/ThemnuocuongWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:duancuoiky/widgets/SuanuocuongWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chiasenuocuong extends StatefulWidget {
  const Chiasenuocuong({super.key});

  @override
  _ChiasenuocuongState createState() => _ChiasenuocuongState();
}

class _ChiasenuocuongState extends State<Chiasenuocuong> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("nuocuong");
  List<Map<String, dynamic>> drinks = [];

  @override
  void initState() {
    super.initState();
    _loadDrink(); // Load data from Firebase on initialization
  }

  // Function to load drink list from Firebase
  Future<void> _loadDrink() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    final snapshot =
        await dbRef.orderByChild('username').equalTo(username).once();
    final data = snapshot.snapshot.value as Map?;

    if (username.isEmpty) return;

    if (data != null) {
      List<Map<String, dynamic>> tempDrinks = [];
      data.forEach((key, value) {
        tempDrinks.add({
          'key': key,
          'ten_nuoc': value['ten_nuoc'] ?? '',
          'huong_dan': value['huong_dan'] ?? '',
          'imageFileName': value['imageFileName'] ?? '',
          'the_loai': value['the_loai'] ?? '',
          'muc_do': value['muc_do'] ?? '',
          'username': value['username'] ?? '',
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
          // Display drinks in a Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title for drink section
                const Text(
                  'Nước uống',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // drink Row (Horizontal Scroll)
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
                          width: 150, // Adjust width for horizontal layout
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // drink Image
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
                              // drink Name
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
                              // drink Category
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
                              // Difficulty Level and Favorite Icon
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

          // Button to add a new drink
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                // Open the add drink dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ThemCongThucn(); // Open add drink dialog
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
                // Open the add drink dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Suanuocuong(); // Open add drink dialog
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
