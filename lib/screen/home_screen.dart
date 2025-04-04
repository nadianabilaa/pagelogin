import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//untuk nantinya beranda
class HomeScreen extends StatelessWidget {
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), actions: [
        IconButton(icon: Icon(Icons.logout), onPressed: () => logout(context))
      ]),
      body: Center(child: Text("Welcome to Home Screen!")),
    );
  }
}
