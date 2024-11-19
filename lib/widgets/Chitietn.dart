import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chitietnuocuong extends StatefulWidget {
  final String dishId;

  const Chitietnuocuong({super.key, required this.dishId});

  @override
  _ChitietnuocuongState createState() => _ChitietnuocuongState();
}

class _ChitietnuocuongState extends State<Chitietnuocuong> {
  final DatabaseReference dbRefNuocuong =
      FirebaseDatabase.instance.ref("nuocuong");
  Map<String, dynamic>? dishDetails;

  @override
  void initState() {
    super.initState();
    _loadDishDetails();
  }

  Future<void> _loadDishDetails() async {
    final dishSnapshot = await dbRefNuocuong.child(widget.dishId).get();
    final dishData = dishSnapshot.value as Map?;

    if (dishData != null) {
      setState(() {
        dishDetails = {
          'ten_nuoc': dishData['ten_nuoc'] ?? '',
          // 'thanhPhan': dishData['thanhPhan'] ?? '',
          'huong_dan': dishData['huong_dan'] ?? '',
          'imageFileName': dishData['imageFileName'] ?? '',
          'the_loai': dishData['the_loai'] ?? '',
          'muc_do': dishData['muc_do'] ?? '',
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
      appBar: AppBar(title: Text(dishDetails!['ten_nuoc'])),
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
            dishDetails!['ten_nuoc'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Thể Loại: ${dishDetails!['the_loai']}",
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
                "Mức Độ: ${dishDetails!['muc_do']}",
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
            dishDetails!['huong_dan'],
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
