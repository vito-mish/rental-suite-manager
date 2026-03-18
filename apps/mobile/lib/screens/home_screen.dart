import 'package:flutter/material.dart';
import '../main.dart';
import 'property/property_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Suite Manager'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
      body: const PropertyListScreen(),
    );
  }
}
