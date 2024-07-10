import 'package:flutter/material.dart';

class ProfileSearchScreen extends StatefulWidget {
  const ProfileSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSearchScreen> createState() => _ProfileSearchState();
}

class _ProfileSearchState extends State<ProfileSearchScreen> {
  final TextEditingController _profileSearchController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _profileSearchController,
            decoration: InputDecoration(
              hintText: 'Search profiles...',
              border: InputBorder.none,
            ),
            onChanged: (query) {
              // Handle profile search logic here
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _profileSearchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: (query) {},
              ),
            ),
          ],
        ));
  }
}
