import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Quanlyu extends StatefulWidget {
  const Quanlyu({super.key});

  @override
  _QuanlyuState createState() => _QuanlyuState();
}

class _QuanlyuState extends State<Quanlyu> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("users");

  List<Map<dynamic, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load users from Firebase
  Future<void> _loadUsers() async {
    dbRef.onValue.listen((event) {
      final userMap = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        users = userMap.entries.map((e) => {"id": e.key, ...e.value}).toList();
      });
    });
  }

  // Edit user data
  Future<void> _editUser(Map<dynamic, dynamic> user) async {
    TextEditingController dobController =
        TextEditingController(text: user['dob']);
    TextEditingController passwordController =
        TextEditingController(text: user['password']);
    TextEditingController phoneController =
        TextEditingController(text: user['phone']);
    TextEditingController roleController =
        TextEditingController(text: user['role']);
    TextEditingController usernameController =
        TextEditingController(text: user['username']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit User"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: dobController,
                    decoration: const InputDecoration(labelText: "DOB")),
                TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password")),
                TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Phone")),
                TextField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: "Role")),
                TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: "Username")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await dbRef.child(user['id']).update({
                  'dob': dobController.text,
                  'password': passwordController.text,
                  'phone': phoneController.text,
                  'role': roleController.text,
                  'username': usernameController.text,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User updated successfully!")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Delete user data
  Future<void> _deleteUser(String userId) async {
    await dbRef.child(userId).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User deleted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  AssetImage(user['image'] ?? 'default_avatar.jpg'),
            ),
            title: Text(user['username'] ?? 'No Name'),
            subtitle: Text("Role: ${user['role']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editUser(user),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(user['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
