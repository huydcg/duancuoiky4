import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("users");

class Dangky extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Dangky(),
      );

  const Dangky({super.key});

  @override
  State<Dangky> createState() => _DangkyState();
}

class _DangkyState extends State<Dangky> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Controller cho tên ảnh
  String role = "user"; // Vai trò mặc định
  File? _image; // Lưu ảnh đã chọn

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _imageUrlController.dispose(); // Giải phóng controller ảnh
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrlController.text = pickedFile.name; // Lấy tên file ảnh
      });
    }
  }

  Future<void> taoTaiKhoan() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final dob = _dobController.text.trim();
    final phone = _phoneController.text.trim();

    if (username.isEmpty || password.isEmpty || dob.isEmpty || phone.isEmpty) {
      _showMessageDialog('Lỗi', 'Vui lòng điền đầy đủ thông tin.');
      return;
    }

    try {
      // Kiểm tra người dùng đã tồn tại chưa
      final snapshot = await _databaseRef.child(username).get();

      if (snapshot.exists) {
        _showMessageDialog('Thêm thất bại', 'Người dùng đã tồn tại.');
      } else {
        // Lấy tên ảnh nếu có
        String? imageName;
        if (_image != null) {
          imageName =
              _imageUrlController.text; // Sử dụng tên file từ controller
        }

        // Thêm người dùng mới vào cơ sở dữ liệu
        await _databaseRef.child(username).set({
          'username': username,
          'password': password,
          'role': role,
          'dob': dob,
          'phone': phone,
          'image': imageName, // Lưu tên ảnh vào cơ sở dữ liệu
        });
        _showMessageDialog('Thêm thành công', 'Người dùng mới đã được thêm.');
      }
    } catch (e) {
      _showMessageDialog('Lỗi', 'Không thể thêm người dùng. Vui lòng thử lại.');
    }
  }

  void _showMessageDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Ký')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng Ký',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Tên đăng nhập',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Mật khẩu',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _dobController,
              decoration: const InputDecoration(
                hintText: 'Ngày sinh (dd/mm/yyyy)',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Số điện thoại',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Chọn Ảnh"),
            ),
            const SizedBox(height: 10),
            if (_image != null) Text("Chọn ảnh: ${_imageUrlController.text}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await taoTaiKhoan(); // Gọi hàm taoTaiKhoan để lưu dữ liệu
              },
              child: const Text(
                'ĐĂNG KÝ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Dang_nhap');
              },
              child: RichText(
                text: TextSpan(
                  text: 'Đã có tài khoản? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Đăng Nhập',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
