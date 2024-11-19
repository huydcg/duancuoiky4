import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:duancuoiky/widgets/AppbarWidget.dart';
import 'package:duancuoiky/widgets/DrawerWidget.dart';

class Congthucnuocuong extends StatelessWidget {
  const Congthucnuocuong({super.key});

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
                  "images/dalgonalatte.jpg",
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
                              "Dalgona Latte",
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
                          "Thành phần: Bột cà phê Espresso 10 gr (2 muỗng cà phê). Sữa tươi không đường 70 ml. Muối nở 1/2 muỗng canh (Baking soda). Đá viên 1 ít. Nước 120 ml. Đường 100 gr.",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Hướng dẫn pha chế: Đầu tiên, bắc cái nồi lên bếp cùng 100gr đường và 50ml nước, tiến hành nấu nước đường với lửa nhỏ trong vòng 5 - 7 phút. Sau khi đường tan đồng thời chuyển sang màu vàng cánh gián thì bạn thêm 1/2 muỗng canh muối nở (baking soda) vào, dùng phới dẹt khuấy đều 3 - 5 phút, đến khi thấy hỗn hợp kẹo đã bông lên thì tắt bếp. Kế đến, chuẩn bị cái khay rồi cho toàn bộ phần kẹo dalgona vừa nấu ra, để nguội cho kẹo đông lại trong vòng 7 - 10 phút. Sau đó, bạn dùng sạn tiến hành đập vụn kẹo ra thành những khối vừa ăn là được. Bạn lấy máy pha cà phê cầm tay, cho vào 10gr (2 muỗng cà phê) bột cà phê Espresso rồi dùng nút ấn chặt. Tiếp tục cho vào máy 70ml nước nóng và đợi trong khoảng 5 - 7 phút đến khi thấy nước cốt cà phê đã ra hết thì bạn cho ra ly. Khi đã chuẩn bị các nguyên liệu xong, bạn lấy 1 cái ly cho vào lần lượt 1 ít đá viên, 70ml sữa tươi không đường, 1 chút kẹo dalgona và phần cà phê Espresso vừa pha xong, vậy là thưởng thức ngay được rồi đó!",
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
                                "Thời gian pha chế: 5 phút.",
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
