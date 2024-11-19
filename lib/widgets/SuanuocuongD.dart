import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuaCongThucn extends StatefulWidget {
  final String drinkId; // ID nước uống cần sửa

  const SuaCongThucn({super.key, required this.drinkId});

  @override
  _SuaCongThucnState createState() => _SuaCongThucnState();
}

class RecipeService {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("nuocuong");

  Future<void> editDrink(String drinkId, Map<String, dynamic> data) async {
    await dbRef.child(drinkId).update(data);
  }
}

class _SuaCongThucnState extends State<SuaCongThucn> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("nuocuong");

  // Controllers for form fields
  final TextEditingController tennuocuongController = TextEditingController();
  final TextEditingController huongdanController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  File? _imageFile;

  // Dropdown values
  String selectedTheloai = 'Giải khát';
  String selectedMucdo = 'Dễ';

  // Predefined options for "Thể Loại" and "Mức Độ"
  final List<String> theloaiOptions = ['Giải khát', 'Rượu', 'Trà'];
  final List<String> mucdoOptions = ['Dễ', 'Vừa', 'Khó'];

  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadDrinkData(widget.drinkId); // Use widget.drinkId
  }

  // Method to load the existing recipe data from Firebase
  Future<void> _loadDrinkData(String drinkId) async {
    DatabaseReference recipeRef = dbRef.child(drinkId);
    DataSnapshot snapshot = await recipeRef.get();

    if (snapshot.exists) {
      var data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        tennuocuongController.text = data['ten_nuoc'] ?? '';
        huongdanController.text = data['huong_dan'] ?? '';
        imageUrlController.text = data['imageFileName'] ?? '';
        selectedTheloai = data['the_loai'] ?? 'Khai Vị';
        selectedMucdo = data['muc_do'] ?? 'Dễ';
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
  Future<void> _saveRecipe(String drinkId) async {
    if (tennuocuongController.text.isEmpty || huongdanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? 'huy';

    // Tạo một map với dữ liệu đã cập nhật để gửi lên Firebase
    final updatedData = {
      'ten_nuoc': tennuocuongController.text,
      'the_loai': selectedTheloai,
      'muc_do': selectedMucdo,
      'imageFileName': imageUrlController.text,
      'huong_dan': huongdanController.text,
      'username': username,
    };

    print(
        'Updated Data: $updatedData'); // In ra để kiểm tra dữ liệu trước khi lưu

    try {
      // Gọi phương thức editDrink để cập nhật món ăn trong Firebase
      await _recipeService.editDrink(drinkId, updatedData);

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
      appBar: AppBar(title: const Text("Sửa Công Thức Nước Uống")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: tennuocuongController,
              decoration: const InputDecoration(labelText: "Tên nước uống"),
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
              controller: huongdanController,
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
              onPressed: () => _saveRecipe(widget.drinkId),
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
