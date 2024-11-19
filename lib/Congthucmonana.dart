import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Để xử lý file ảnh

class ThemCongThuc extends StatefulWidget {
  const ThemCongThuc({super.key});

  @override
  State<ThemCongThuc> createState() => _ThemCongThucState();
}

class _ThemCongThucState extends State<ThemCongThuc> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _tenMonAnController = TextEditingController();
  final TextEditingController _thanhPhanController = TextEditingController();
  final TextEditingController _huongDanController = TextEditingController();
  final TextEditingController _theLoaiController = TextEditingController();
  final TextEditingController _mucDoController = TextEditingController();

  // Hiển thị dialog để nhập thêm thông tin
  void _showAddRecipeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tiêu đề dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    const Text(
                      "Thêm Công Thức Món Ăn",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                // Các trường nhập liệu
                TextField(
                  controller: _tenMonAnController,
                  decoration: const InputDecoration(labelText: 'Tên món ăn'),
                ),
                TextField(
                  controller: _thanhPhanController,
                  decoration: const InputDecoration(labelText: 'Thành phần'),
                ),
                TextField(
                  controller: _huongDanController,
                  decoration:
                      const InputDecoration(labelText: 'Hướng dẫn nấu ăn'),
                ),
                TextField(
                  controller: _theLoaiController,
                  decoration: const InputDecoration(labelText: 'Thể loại'),
                ),
                TextField(
                  controller: _mucDoController,
                  decoration: const InputDecoration(labelText: 'Mức độ'),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    _image == null
                        ? const Text('Chưa chọn ảnh')
                        : Image.file(
                            File(_image!.path),
                            width: 100,
                            height: 100,
                          ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _getImage,
                      child: const Text('Chọn ảnh'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Các nút hành động
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveRecipe(); // Lưu công thức khi nhấn nút "Lưu"
                        Navigator.pop(context); // Đóng dialog
                      },
                      child: const Text("Lưu"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Đóng dialog nếu nhấn "Hủy"
                      },
                      child: const Text("Hủy"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Chọn ảnh từ thư viện
  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  // Lưu công thức vào Firebase
  Future<void> _saveRecipe() async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref("monan");

    // Lấy các giá trị nhập từ người dùng
    String tenMonAn = _tenMonAnController.text;
    String thanhPhan = _thanhPhanController.text;
    String huongDan = _huongDanController.text;
    String theloai = _theLoaiController.text;
    String mucdo = _mucDoController.text;

    // Lưu tên file ảnh (nếu có)
    String imageFileName = '';
    if (_image != null) {
      // Lấy tên file từ đường dẫn của ảnh
      imageFileName = _image!.name; // `name` là tên file của ảnh
    }

    // Thêm một công thức mới vào Firebase Realtime Database
    await dbRef.push().set({
      'tenmonan': tenMonAn,
      'thanhphan': thanhPhan,
      'huongdan': huongDan,
      'theloai': theloai,
      'mucdo': mucdo,
      'imageFileName': imageFileName, // Tên file ảnh
    });

    // Xử lý sau khi lưu thành công
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Công thức đã được lưu")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Công Thức Món Ăn')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: _showAddRecipeDialog, // Mở dialog khi nhấn nút "Thêm"
              child: const Text('Thêm Công Thức'),
            ),
          ],
        ),
      ),
    );
  }
}
