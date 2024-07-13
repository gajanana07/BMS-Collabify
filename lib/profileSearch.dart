import 'package:classico/profile_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileSearchScreen extends StatefulWidget {
  const ProfileSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSearchScreen> createState() => _ProfileSearchState();
}

class _ProfileSearchState extends State<ProfileSearchScreen> {
  final TextEditingController _profileSearchController =
      TextEditingController();
  List<DocumentSnapshot<Map<String, dynamic>>> _profiles = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _profiles = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _profileSearchController,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
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
                hintText: 'Search Profiles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _profiles.length,
              itemBuilder: (context, index) {
                DocumentSnapshot<Map<String, dynamic>> profile =
                    _profiles[index];
                String name = profile['firstName'];
                String email = profile['email'];
                String imageUrl = profile['imageUrl'];

                // Check if profile matches search query or if query is empty
                if (_searchQuery.isEmpty ||
                    name.toLowerCase().contains(_searchQuery.toLowerCase())) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetailsScreen(
                            profile: profile,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            imageUrl != null ? NetworkImage(imageUrl) : null,
                        child: imageUrl == null ? Icon(Icons.person) : null,
                      ),
                      title: Text(name),
                      subtitle: Text(email),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
