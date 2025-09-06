import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_screen.dart';
import 'list_toilets.dart';
import 'sign_in_screen.dart';
import '../core/services/supabase_service.dart';

class ListToiletsTemp extends StatefulWidget {
  const ListToiletsTemp({Key? key}) : super(key: key);

  @override
  State<ListToiletsTemp> createState() => _ListToiletsTempState();
}

class _ListToiletsTempState extends State<ListToiletsTemp> {
  final toiletTempStream = Supabase.instance.client
      .from('toilets')
      .stream(primaryKey: ['id']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Text(
                'Toilet Finder London',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map View'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('List View'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListToilets()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () {
                SupabaseService().signOut();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('List Toilets')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: toiletTempStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading stream...'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return Column(
            children: List<Widget>.generate(
              snapshot.data!.length,
              (index) => Text(snapshot.data![index]['name']),
            ),
          );
        },
      ),
    );
  }
}
