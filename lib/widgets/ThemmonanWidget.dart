import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'dart:io'; // For File
import 'package:shared_preferences/shared_preferences.dart';

class ThemCongThucm extends StatefulWidget {
  const ThemCongThucm({super.key});

  @override
  _ThemCongThucmState createState() => _ThemCongThucmState();
}

class _ThemCongThucmState extends State<ThemCongThucm> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");

  // Controllers for form fields
  final TextEditingController tenMonAnController = TextEditingController();
  final TextEditingController huongDanController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // Dropdown values
  String selectedTheloai = 'Khai Vị';
  String selectedMucdo = 'Dễ';

  // Predefined options for "Thể Loại" and "Mức Độ"
  final List<String> theloaiOptions = ['Khai Vị', 'Món Chính', 'Tráng Miệng'];
  final List<String> mucdoOptions = ['Dễ', 'Vừa', 'Khó'];

  // Variable to hold selected image file
  File? _imageFile;

  // Method to pick an image
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

  // Method to save the new recipe to Firebase
  Future<void> _saveRecipe() async {
    if (tenMonAnController.text.isEmpty || huongDanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? 'Anonymous';

    await dbRef.push().set({
      'tenMonAn': tenMonAnController.text,
      'theloai': selectedTheloai,
      'mucdo': selectedMucdo,
      'imageFileName': imageUrlController.text, // Save the image name or path
      'huongDan': huongDanController.text,
      'username': username,
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Thêm Công Thức Mới"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tenMonAnController,
              decoration: const InputDecoration(labelText: "Tên Món Ăn"),
            ),
            const SizedBox(height: 10),
            // Dropdown for "Thể Loại"
            DropdownButtonFormField<String>(
              value: selectedTheloai,
              decoration: const InputDecoration(labelText: "Thể Loại"),
              items: theloaiOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedTheloai = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            // Dropdown for "Mức Độ"
            DropdownButtonFormField<String>(
              value: selectedMucdo,
              decoration: const InputDecoration(labelText: "Mức Độ"),
              items: mucdoOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedMucdo = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            // Button to pick image
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Chọn Ảnh"),
            ),
            const SizedBox(height: 10),
            // Show selected image file name
            if (_imageFile != null)
              Text("Chọn ảnh: ${imageUrlController.text}"),
            const SizedBox(height: 10),
            TextField(
              controller: huongDanController,
              decoration: const InputDecoration(labelText: "Hướng Dẫn"),
              maxLines: 4, // Allows multi-line input for detailed instructions
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _saveRecipe,
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}
