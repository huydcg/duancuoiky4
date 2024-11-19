import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/avatar.jpg"),
              ),
              accountName: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "VKU",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              accountEmail: Text(
                "vkuviethan@gmail.com",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.red,
          ),
          // list danh muc
          ListTile(
            leading: const Icon(
              CupertinoIcons.home,
              color: Colors.red,
            ),
            title: const Text(
              "Trang Chủ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'Trang_chu');
            },
          ),

          const Divider(
            color: Colors.red,
          ),

          ListTile(
            leading: const Icon(
              Icons.person_pin_circle_outlined,
              color: Colors.red,
            ),
            title: const Text(
              "Thông Tin Tài Khoản",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'Thong_tin_tai_khoan');
            },
          ),

          const Divider(
            color: Colors.red,
          ),

          ListTile(
            leading: const Icon(
              CupertinoIcons.heart_circle_fill,
              color: Colors.red,
            ),
            title: const Text(
              "Công Thức Yêu Thích",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'Cong_thuc_yeu_thich');
            },
          ),

          const Divider(
            color: Colors.red,
          ),

          ListTile(
            leading: const Icon(
              Icons.share_sharp,
              color: Colors.red,
            ),
            title: const Text(
              "Chia Sẻ Món Ăn",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'Chia_se_mon_an');
            },
          ),

          const Divider(
            color: Colors.red,
          ),

          ListTile(
            leading: const Icon(
              Icons.share_sharp,
              color: Colors.red,
            ),
            title: const Text(
              "Chia Sẻ Nước Uống",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'Chia_se_nuoc_uong');
            },
          ),

          const Divider(
            color: Colors.red,
          ),

          ListTile(
            leading: const Icon(
              CupertinoIcons.settings_solid,
              color: Colors.red,
            ),
            title: const Text(
              "Cài Đặt",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'Cai_dat');
            },
          ),

          const Divider(
            color: Colors.red,
          ),

          ListTile(
            leading: const Icon(Icons.exit_to_app_outlined, color: Colors.red),
            title: const Text(
              "Đăng Xuất",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('LinU');

              Navigator.pushNamedAndRemoveUntil(
                  context, 'Dang_nhap', (route) => false);
            },
          ),

          const Divider(
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
