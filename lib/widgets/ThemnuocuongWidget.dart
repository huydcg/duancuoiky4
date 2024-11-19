import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ThemCongThucn extends StatefulWidget {
  const ThemCongThucn({super.key});

  @override
  _ThemCongThucnState createState() => _ThemCongThucnState();
}

class _ThemCongThucnState extends State<ThemCongThucn> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("nuocuong");

  // Controllers for form fields
  final TextEditingController tennuocuongController = TextEditingController();
  final TextEditingController huongdanController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController thanhphanController = TextEditingController();

  // Dropdown values
  String selectedTheloai = 'Giải khát';
  String selectedMucdo = 'Dễ';

  // Predefined options for "Thể Loại" and "Mức Độ"
  final List<String> theloaiOptions = ['Giải khát', 'Rượu', 'Trà'];
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
  Future<void> _saveDrink() async {
    if (tennuocuongController.text.isEmpty || huongdanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? 'Anonymous';

    await dbRef.push().set({
      'ten_nuoc': tennuocuongController.text,
      'the_loai': selectedTheloai,
      'muc_do': selectedMucdo,
      'imageFileName': imageUrlController.text,
      // 'thanh_phan': thanhphanController.text,
      'huong_dan': huongdanController.text,
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
              controller: tennuocuongController,
              decoration: const InputDecoration(labelText: "Tên nước uống"),
            ),
            const SizedBox(height: 10),
            // TextField(
            //   controller: thanhphanController,
            //   decoration: const InputDecoration(labelText: "Thành phần"),
            // ),
            const SizedBox(height: 10),
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
              controller: huongdanController,
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
          onPressed: _saveDrink,
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}
