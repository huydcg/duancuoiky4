import 'package:duancuoiky/widgets/SuanuocuongD.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Suanuocuong extends StatefulWidget {
  const Suanuocuong({super.key});

  @override
  _SuanuocuongState createState() => _SuanuocuongState();
}

class _SuanuocuongState extends State<Suanuocuong> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("nuocuong");
  List<Map<String, dynamic>> drinks = [];

  @override
  void initState() {
    super.initState();
    _loadDrinks();
  }

  // Function to load drink list from Firebase
  Future<void> _loadDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('LinU') ?? '';

    if (username.isEmpty) return;

    final snapshot =
        await dbRef.orderByChild('username').equalTo(username).once();
    final data = snapshot.snapshot.value as Map?;

    if (data != null) {
      List<Map<String, dynamic>> tempDrinks = [];
      data.forEach((key, value) {
        tempDrinks.add({
          'key': key,
          'ten_nuoc': value['ten_nuoc'] ?? '',
          'username': value['username'] ?? '',
        });
      });

      setState(() {
        drinks = tempDrinks;
      });
    }
  }

  // Function to delete a drink by its key
  Future<void> _deleteDrink(String key) async {
    await dbRef.child(key).remove();
    // Remove the deleted drink directly from the local list to reflect changes immediately
    setState(() {
      drinks.removeWhere((drink) => drink['key'] == key);
    });
  }

  // Function to show the edit screen for a drink
  void _editDrink(String key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuaCongThucn(drinkId: key),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chủ')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nước Uống',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Display the list of drink names with edit and delete buttons
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            drink['ten_nuoc'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editDrink(drink['key']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteDrink(drink['key']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
