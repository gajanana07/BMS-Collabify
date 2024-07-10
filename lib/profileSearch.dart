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
  List<DocumentSnapshot> _profiles = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    QuerySnapshot querySnapshot =
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
                DocumentSnapshot profile = _profiles[index];
                String name = profile['firstName'];
                String email = profile['email'];

                if (_searchQuery.isEmpty ||
                    name.toLowerCase().contains(_searchQuery.toLowerCase())) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profile['imageUrl'] != null
                          ? NetworkImage(profile['imageUrl'])
                          : null,
                      child: profile['imageUrl'] == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    title: Text(name),
                    subtitle: Text('$email'),
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
