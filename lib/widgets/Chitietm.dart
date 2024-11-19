import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chitietmonan extends StatefulWidget {
  final String dishId;

  const Chitietmonan({super.key, required this.dishId});

  @override
  _ChitietmonanState createState() => _ChitietmonanState();
}

class _ChitietmonanState extends State<Chitietmonan> {
  final DatabaseReference dbRefMonan = FirebaseDatabase.instance.ref("monan");
  Map<String, dynamic>? dishDetails;

  @override
  void initState() {
    super.initState();
    _loadDishDetails();
  }

  Future<void> _loadDishDetails() async {
    final dishSnapshot = await dbRefMonan.child(widget.dishId).get();
    final dishData = dishSnapshot.value as Map?;

    if (dishData != null) {
      setState(() {
        dishDetails = {
          'tenMonAn': dishData['tenMonAn'] ?? '',
          // 'thanhPhan': dishData['thanhPhan'] ?? '',
          'huongDan': dishData['huongDan'] ?? '',
          'imageFileName': dishData['imageFileName'] ?? '',
          'theloai': dishData['theloai'] ?? '',
          'mucdo': dishData['mucdo'] ?? '',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dishDetails == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(dishDetails!['tenMonAn'])),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dish Image
          AspectRatio(
            aspectRatio: 4 / 1,
            child: dishDetails!['imageFileName'].startsWith('http')
                ? Image.network(
                    dishDetails!['imageFileName'],
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    dishDetails!['imageFileName'],
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 20),
          // Dish Name and Category
          Text(
            dishDetails!['tenMonAn'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Thể Loại: ${dishDetails!['theloai']}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          // Difficulty Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mức Độ: ${dishDetails!['mucdo']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),
          //
          // const Text(
          //   "Thành Phần:",
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   dishDetails!['thanhPhan'],
          //   style: const TextStyle(
          //     fontSize: 16,
          //     height: 1.5,
          //   ),
          //   textAlign: TextAlign.justify,
          // ),
          // const SizedBox(height: 20),
          //
          const Text(
            "Hướng Dẫn:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dishDetails!['huongDan'],
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
