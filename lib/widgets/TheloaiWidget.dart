import 'package:flutter/material.dart';

class TheLoaiWidget extends StatelessWidget {
  const TheLoaiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            // mặt hàng duy nhất
            //for (int i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Image.asset(
                  "images/nuong.jpg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Image.asset(
                  "images/chay.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Image.asset(
                  "images/chien.jpg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Image.asset(
                  "images/xao.jpg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Image.asset(
                  "images/canh.jpg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
