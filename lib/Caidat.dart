import 'package:duancuoiky/widgets/AppbarWidget.dart';
import 'package:duancuoiky/widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';

class Caidat extends StatelessWidget {
  const Caidat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(),
              // Cài đặt thông báo
              SettingCard(
                icon: Icons.notifications,
                label: 'Cài đặt thông báo',
              ),

              // Câu hỏi thường gặp
              SettingCard(
                icon: Icons.question_answer,
                label: 'Câu hỏi thường gặp',
              ),

              // Chọn ngôn ngữ
              SettingCard(
                icon: Icons.language,
                label: 'Chọn ngôn ngữ',
              ),

              // Giao diện sáng tối
              SettingCard(
                icon: Icons.brightness_6,
                label: 'Giao diện sáng tối',
              ),

              // Thay đổi mật khẩu
              SettingCard(
                icon: Icons.lock,
                label: 'Thay đổi mật khẩu',
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}

class SettingCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const SettingCard({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Xử lý sự kiện nhấn
        // Bạn có thể chuyển hướng đến các trang tương ứng ở đây
      },
      child: Container(
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
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
