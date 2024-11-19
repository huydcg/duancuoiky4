import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuaCongThucm extends StatefulWidget {
  final String recipeId; // ID món ăn cần sửa

  const SuaCongThucm({super.key, required this.recipeId});

  @override
  _SuaCongThucmState createState() => _SuaCongThucmState();
}

class RecipeService {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");

  Future<void> editRecipe(String recipeId, Map<String, dynamic> data) async {
    await dbRef.child(recipeId).update(data);
  }
}

class _SuaCongThucmState extends State<SuaCongThucm> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");

  // Controllers for form fields
  final TextEditingController tenMonAnController = TextEditingController();
  final TextEditingController huongDanController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  File? _imageFile;

  // Dropdown values
  String selectedTheloai = 'Khai Vị';
  String selectedMucdo = 'Dễ';

  // Predefined options for "Thể Loại" and "Mức Độ"
  final List<String> theloaiOptions = ['Khai Vị', 'Món Chính', 'Tráng Miệng'];
  final List<String> mucdoOptions = ['Dễ', 'Vừa', 'Khó'];

  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadRecipeData(widget.recipeId); // Use widget.recipeId
  }

  // Method to load the existing recipe data from Firebase
  Future<void> _loadRecipeData(String recipeId) async {
    DatabaseReference recipeRef = dbRef.child(recipeId);
    DataSnapshot snapshot = await recipeRef.get();

    if (snapshot.exists) {
      var data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        tenMonAnController.text = data['tenMonAn'] ?? '';
        huongDanController.text = data['huongDan'] ?? '';
        imageUrlController.text = data['imageFileName'] ?? '';
        selectedTheloai = data['theloai'] ?? 'Khai Vị';
        selectedMucdo = data['mucdo'] ?? 'Dễ';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Use gallery to select image

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Save the image file
        imageUrlController.text =
            pickedFile.name; // Save the image name (or path if needed)
      });
    }
  }

  // Method to save the updated recipe to Firebase
  Future<void> _saveRecipe(String recipeId) async {
    if (tenMonAnController.text.isEmpty || huongDanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? 'huy';

    // Tạo một map với dữ liệu đã cập nhật để gửi lên Firebase
    final updatedData = {
      'tenMonAn': tenMonAnController.text,
      'theloai': selectedTheloai,
      'mucdo': selectedMucdo,
      'imageFileName': imageUrlController.text,
      'huongDan': huongDanController.text,
      'username': username,
    };

    print(
        'Updated Data: $updatedData'); // In ra để kiểm tra dữ liệu trước khi lưu

    try {
      // Gọi phương thức editRecipe để cập nhật món ăn trong Firebase
      await _recipeService.editRecipe(recipeId, updatedData);

      // Hiển thị thông báo xác nhận và quay lại màn hình trước
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật công thức thành công!")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Lỗi khi lưu dữ liệu: $e'); // In ra lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã có lỗi xảy ra. Vui lòng thử lại.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sửa Công Thức Món Ăn")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: tenMonAnController,
              decoration: const InputDecoration(labelText: "Tên Món Ăn"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedTheloai,
              decoration: const InputDecoration(labelText: "Thể Loại"),
              onChanged: (value) {
                setState(() {
                  selectedTheloai = value!;
                });
              },
              items: theloaiOptions.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: huongDanController,
              decoration: const InputDecoration(labelText: "Hướng Dẫn"),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Chọn Ảnh"),
            ),
            const SizedBox(height: 10),
            // Show selected image file name
            if (_imageFile != null)
              Text("Chọn ảnh: ${imageUrlController.text}"),
            // const SizedBox(height: 10),
            // TextField(
            //   controller: imageUrlController,
            //   decoration: const InputDecoration(labelText: "Link Hình Ảnh"),
            // ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedMucdo,
              decoration: const InputDecoration(labelText: "Mức Độ"),
              onChanged: (value) {
                setState(() {
                  selectedMucdo = value!;
                });
              },
              items: mucdoOptions.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () => _saveRecipe(widget.recipeId),
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
