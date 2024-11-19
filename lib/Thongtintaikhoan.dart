import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:duancuoiky/widgets/AppbarWidget.dart';
import 'package:duancuoiky/widgets/DrawerWidget.dart';

// Firebase Realtime Database Reference
final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('users');

class Thongtintaikhoan extends StatefulWidget {
  final String username; // Add username parameter

  const Thongtintaikhoan({super.key, required this.username});

  @override
  _ThongtintaikhoanState createState() => _ThongtintaikhoanState();
}

class _ThongtintaikhoanState extends State<Thongtintaikhoan> {
  String? username;
  String? email;
  String? name;
  String? dob;
  String? phone;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadLoginStateAndUserInfo(); // Load login state and fetch user data
  }

  Future<void> _loadLoginStateAndUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('LinU'); // Retrieve stored username

    if (storedUsername != null) {
      setState(() {
        username = storedUsername;
      });
      await _getUserInfo(storedUsername); // Fetch user data from Firebase
    } else {
      // Redirect to login if no user is logged in
      Navigator.pushReplacementNamed(context, 'Dangnhap');
    }
  }

  Future<void> _getUserInfo(String username) async {
    try {
      // Retrieve user data based on username
      final snapshot = await _databaseRef.child(username).get();

      if (snapshot.exists) {
        var data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          email = data['username']; // Assuming 'username' is the email
          name = data['username']; // Changed to 'name' instead of 'username'
          dob = data['dob'];
          phone = data['phone'];
          imageUrl = data['image']; // Image URL from Firebase
        });
      } else {
        print('Không tìm thấy người dùng');
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin người dùng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarWidget(),
              // Avatar
              imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: SizedBox(
                        width: 200.0, // Set fixed width for the circle
                        height: 200.0, // Set fixed height for the circle
                        child: AspectRatio(
                          aspectRatio:
                              1.0, // Ensure square aspect ratio for the circle
                          child: imageUrl!.startsWith('http')
                              ? Image.network(
                                  imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  imageUrl!, // Assuming image is a local path
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    )
                  : ClipOval(
                      child: SizedBox(
                        width: 200.0, // Set fixed width for the default avatar
                        height:
                            200.0, // Set fixed height for the default avatar
                        child: AspectRatio(
                          aspectRatio:
                              1.0, // Ensure square aspect ratio for the circle
                          child: Image.asset(
                            'assets/images/avatar.jpg', // Corrected path for default image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

              // Gmail (Email)
              InfoCard(
                icon: Icons.email,
                label: 'Gmail',
                value: email ?? 'Đang tải...',
              ),

              // Họ Và Tên
              InfoCard(
                icon: Icons.person,
                label: 'Họ Và Tên',
                value: name ?? 'Đang tải...',
              ),

              // Ngày Sinh
              InfoCard(
                icon: Icons.calendar_today,
                label: 'Ngày Sinh',
                value: dob ?? 'Đang tải...',
              ),

              // Số Điện Thoại
              InfoCard(
                icon: Icons.phone,
                label: 'Số Điện Thoại',
                value: phone ?? 'Đang tải...',
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle edit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Chỉnh Sửa Thông Tin',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 30),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
