import 'package:duancuoiky/Quanlyu.dart';
import 'package:duancuoiky/Trangchua.dart';
import 'package:duancuoiky/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:duancuoiky/Caidat.dart';
import 'package:duancuoiky/Chiasemonan.dart';
import 'package:duancuoiky/Chiasenuocuong.dart';
import 'package:duancuoiky/Congthucmonan.dart';
import 'package:duancuoiky/Congthucnuocuong.dart';
import 'package:duancuoiky/Congthucyeuthich.dart';
import 'package:duancuoiky/Dangky.dart';
import 'package:duancuoiky/Dangnhap.dart';
import 'package:duancuoiky/Thongtintaikhoan.dart';
import 'package:duancuoiky/Trangchu.dart';
import 'package:duancuoiky/splashscreen/Splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Công Thức Món Ăn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F3),
      ),
      routes: {
        "/": (context) => const SplashScreen(),
        "Trang_chu": (context) => const Trangchu(),
        "Trang_chua": (context) => const Trangchua(),
        "Dang_nhap": (context) => const Dangnhap(),
        "Dang_ky": (context) => const Dangky(),
        "Chia_se_mon_an": (context) => const Chiasemonan(),
        "Chia_se_nuoc_uong": (context) => const Chiasenuocuong(),
        "Cong_thuc_mon_an": (context) => const Congthucmonan(),
        "Cong_thuc_nuoc_uong": (context) => const Congthucnuocuong(),
        "Cong_thuc_yeu_thich": (context) => const Congthucyeuthich(),
        "Thong_tin_tai_khoan": (context) => const Thongtintaikhoan(
              username: '',
            ),
        "Quan_ly_u": (context) => const Quanlyu(),
        "Cai_dat": (context) => const Caidat(),
      },
    );
  }
}
