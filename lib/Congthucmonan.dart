import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:duancuoiky/widgets/AppbarWidget.dart';
import 'package:duancuoiky/widgets/DrawerWidget.dart';

class Congthucmonan extends StatelessWidget {
  const Congthucmonan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 5,
        ),
        child: ListView(
          children: [
            const AppBarWidget(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity, // Chiếm hết chiều ngang
                height: 200,
                child: Image.asset(
                  "images/thitkhohotvit.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //-----------------------------
            Arc(
              edge: Edge.TOP,
              arcType: ArcType.CONVEY,
              height: 30,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 35, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              onRatingUpdate: (rating) {},
                              initialRating: 4,
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                            ),
                            const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Thịt Kho Hột Vịt",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Mức Độ: Dễ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Thành phần: 500 gram  ba chỉ heo loại ngon 4 trái hột vịt luộc bóc vỏ 3 tép hành tím, tỏi 500 mililit nước dừa tươi 1 muỗng cà phê nước màu dừa hoặc 2 muỗng cà phê nước màu caramel 1/2 muỗng canh Hạt nêm Knorr Thịt Thăn, Xương Ống & Tuỷ 1 muỗng canh nước mắm Knorr Ngon Nguyên Bản 5 gram pepper, ớt, hành lá trang trí.",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Hướng dẫn nấu ăn: Trụng sơ thịt, cắt miếng dày 2.5-3cm. Ướp thịt với hành tím, tỏi băm, hạt nêm Knorr, nước màu, nước mắm Knorr. Ướp trong 15p. Cho thịt vào nồi và đun nóng bếp. Xào thịt trong 2-3p để thịt săn lại và lên màu nâu đỏ đẹp. Cho Nước dừa vào vừa đủ ngập mặt thịt. Ninh lửa vừa và đậy nắp nồi trong 30p. Sau 30p mở nắp và cho trứng vào. Tiếp tục ninh nhỏ lửa đến khi thịt chín mềm và sốt sánh (tầm 30p nữa). Nêm nếm lại cho vừa vị. Thêm tiêu, hành lá trang trí. Dùng nóng.",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.clock, color: Colors.red),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                              ),
                              Text(
                                "Thời gian nấu: 30 phút.",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
