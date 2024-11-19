import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Save login state
Future<void> saveLoginState(String username, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('LinU', username); // Save the username
  await prefs.setString('userRole', role); // Save the role
  await prefs.setBool('isLin', true); // Mark user as logged in
}

// Firebase Database reference
final DatabaseReference dbRef = FirebaseDatabase.instance.ref("users");

class Dangnhap extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Dangnhap(),
      );

  const Dangnhap({super.key});

  @override
  State<Dangnhap> createState() => _DangnhapState();
}

class _DangnhapState extends State<Dangnhap> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String role = "user"; // Default role

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> DangnhapV() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final snapshot =
          await dbRef.orderByChild('username').equalTo(username).once();

      if (snapshot.snapshot.value != null) {
        final userData = (snapshot.snapshot.value as Map).values.first;
        if (userData['password'] == password) {
          // Store role from database or fallback to default
          role = userData['role'] ?? "user";

          print("Đăng nhập thành công! Dữ liệu người dùng: $userData");
          print("Vai trò người dùng: $role");

          // Save login state
          await saveLoginState(username, role);

          // Ensure no pending operations before navigating
          if (mounted) {
            // Navigate based on role
            if (role == 'admin') {
              Navigator.pushReplacementNamed(context, 'Trang_chua');
            } else {
              Navigator.pushReplacementNamed(context, 'Trang_chu');
            }
          }
        } else {
          _showMessageDialog('Đăng nhập thất bại', 'Sai mật khẩu.');
        }
      } else {
        _showMessageDialog('Đăng nhập thất bại', 'Người dùng không tồn tại.');
      }
    } catch (e) {
      _showMessageDialog('Lỗi', 'Đăng nhập không thành công.');
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
      appBar: AppBar(title: const Text('Đăng Nhập')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng Nhập',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Tên người dùng',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Mật Khẩu',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DangnhapV();
              },
              child: const Text(
                'ĐĂNG NHẬP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Dang_ky');
              },
              child: RichText(
                text: TextSpan(
                  text: 'Bạn chưa có tài khoản? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Đăng Ký',
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
