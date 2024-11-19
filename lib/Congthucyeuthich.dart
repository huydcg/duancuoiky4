import 'package:duancuoiky/widgets/Chitietm.dart';
import 'package:duancuoiky/widgets/Chitietn.dart';
import 'package:duancuoiky/widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Congthucyeuthich extends StatefulWidget {
  const Congthucyeuthich({super.key});

  @override
  _CongthucyeuthichState createState() => _CongthucyeuthichState();
}

class _CongthucyeuthichState extends State<Congthucyeuthich> {
  final DatabaseReference dbRefMonan = FirebaseDatabase.instance.ref("monan");
  final DatabaseReference dbRefNuocuong =
      FirebaseDatabase.instance.ref("nuocuong");
  final DatabaseReference dbRefYeuthich =
      FirebaseDatabase.instance.ref("yeuthich");
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> drinks = [];

  @override
  void initState() {
    super.initState();
    _loadFavorite();
    _loadFavorited();
  }

  // Function to load favorite recipes from yeuthich and then fetch corresponding recipes from monan
  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    if (username.isEmpty) return;

    final favoriteSnapshot =
        await dbRefYeuthich.orderByChild('username').equalTo(username).once();
    final favoriteData = favoriteSnapshot.snapshot.value as Map?;

    if (favoriteData != null) {
      List<String> favoriteIds = [];
      favoriteData.forEach((key, value) {
        if (value['category'] == 'monan') {
          favoriteIds.add(value['Id']); // Collect all favorite dish IDs
        }
      });

      List<Map<String, dynamic>> tempRecipes = [];
      for (String id in favoriteIds) {
        final dishSnapshot = await dbRefMonan.child(id).get();
        final dishData = dishSnapshot.value as Map?;

        if (dishData != null) {
          tempRecipes.add({
            'key': id,
            'tenMonAn': dishData['tenMonAn'] ?? '',
            'thanhPhan': dishData['thanhPhan'] ?? '',
            'huongDan': dishData['huongDan'] ?? '',
            'imageFileName': dishData['imageFileName'] ?? '',
            'theloai': dishData['theloai'] ?? '',
            'mucdo': dishData['mucdo'] ?? '',
            'username': dishData['username'] ?? '',
          });
        }
      }

      setState(() {
        recipes = tempRecipes;
      });
    }
  }

  //
  Future<void> _loadFavorited() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    if (username.isEmpty) return;

    final favoriteSnapshot =
        await dbRefYeuthich.orderByChild('username').equalTo(username).once();
    final favoriteData = favoriteSnapshot.snapshot.value as Map?;

    if (favoriteData != null) {
      List<String> favoriteIds = [];
      favoriteData.forEach((key, value) {
        if (value['category'] == 'nuocuong') {
          favoriteIds.add(value['Id']); // Collect all favorite dish IDs
        }
      });

      List<Map<String, dynamic>> tempDrinks = [];
      for (String id in favoriteIds) {
        final dishSnapshot = await dbRefNuocuong.child(id).get();
        final dishData = dishSnapshot.value as Map?;

        if (dishData != null) {
          tempDrinks.add({
            'key': id,
            'ten_nuoc': dishData['ten_nuoc'] ?? '',
            'huong_dan': dishData['huong_dan'] ?? '',
            'imageFileName': dishData['imageFileName'] ?? '',
            'the_loai': dishData['the_loai'] ?? '',
            'muc_do': dishData['muc_do'] ?? '',
            'username': dishData['username'] ?? '',
          });
        }
      }

      setState(() {
        drinks = tempDrinks;
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //         title:
  //             const Text('Món Ăn Yêu Thích')), //thêm phần Nước uống yêu thích
  //     body: ListView(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Món Ăn Yêu Thích',
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Row(
  //                   children: recipes.map((recipe) {
  //                     String imageUrl = recipe['imageFileName'];
  //                     if (imageUrl.isEmpty) {
  //                       imageUrl = 'images/xao.png';
  //                     }

  //                     return Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 7),
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(10),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.grey.withOpacity(0.5),
  //                               spreadRadius: 3,
  //                               blurRadius: 10,
  //                               offset: const Offset(0, 3),
  //                             ),
  //                           ],
  //                         ),
  //                         width: 150,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             AspectRatio(
  //                               aspectRatio: 1.0,
  //                               child: imageUrl.startsWith('http')
  //                                   ? Image.network(
  //                                       imageUrl,
  //                                       fit: BoxFit.cover,
  //                                     )
  //                                   : Image.asset(
  //                                       imageUrl,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                             ),
  //                             const SizedBox(height: 8),
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 10),
  //                               child: Text(
  //                                 recipe['tenMonAn'],
  //                                 style: const TextStyle(
  //                                   fontSize: 17,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 10),
  //                               child: Text(
  //                                 "Thể Loại: ${recipe['theloai']}",
  //                                 style: const TextStyle(
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(height: 12),
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 10),
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     "Mức Độ: ${recipe['mucdo']}",
  //                                     style: const TextStyle(
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Colors.red,
  //                                     ),
  //                                   ),
  //                                   const Icon(
  //                                     Icons.favorite,
  //                                     color: Colors.red,
  //                                     size: 17,
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             //
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 10),
  //                               child: ElevatedButton(
  //                                 onPressed: () {
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                       builder: (context) =>
  //                                           Chitietmonan(dishId: recipe['key']),
  //                                     ),
  //                                   );
  //                                 },
  //                                 child: const Text('Chi tiết'),
  //                               ),
  //                             ),
  //                             //
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     drawer: const DrawerWidget(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu Thích'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Món Ăn Yêu Thích
                const Text(
                  'Món Ăn Yêu Thích',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: recipes.map((recipe) {
                      String imageUrl = recipe['imageFileName'];
                      if (imageUrl.isEmpty) {
                        imageUrl = 'images/xao.png';
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Container(
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
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: imageUrl.startsWith('http')
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  recipe['tenMonAn'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Thể Loại: ${recipe['theloai']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mức Độ: ${recipe['mucdo']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 17,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Chitietmonan(dishId: recipe['key']),
                                      ),
                                    );
                                  },
                                  child: const Text('Chi tiết'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Nước Uống Yêu Thích
                const Text(
                  'Nước Uống Yêu Thích',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: drinks.map((drink) {
                      String imageUrl = drink['imageFileName'];
                      if (imageUrl.isEmpty) {
                        imageUrl = 'images/drink.png';
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Container(
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
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: imageUrl.startsWith('http')
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  drink['ten_nuoc'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Thể Loại: ${drink['the_loai']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mức Độ: ${drink['muc_do']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 17,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Chitietnuocuong(
                                            dishId: drink['key']),
                                      ),
                                    );
                                  },
                                  child: const Text('Chi tiết'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
    );
  }
}
