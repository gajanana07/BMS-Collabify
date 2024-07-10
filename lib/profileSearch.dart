import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileSearchScreen extends StatefulWidget {
  const ProfileSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSearchScreen> createState() => _ProfileSearchScreenState();
}

class _ProfileSearchScreenState extends State<ProfileSearchScreen> {
  final TextEditingController _profileSearchController =
      TextEditingController();
<<<<<<< HEAD
  final List<Map<String, dynamic>> _allProfiles = [
    {'name': 'John Doe', 'profilePicUrl': 'https://via.placeholder.com/150'},
    {'name': 'Jane Smith', 'profilePicUrl': 'https://via.placeholder.com/150'},
    {
      'name': 'Alice Johnson',
      'profilePicUrl': 'https://via.placeholder.com/150'
    },
    {'name': 'Bob Brown', 'profilePicUrl': 'https://via.placeholder.com/150'},
    {
      'name': 'Charlie Davis',
      'profilePicUrl': 'https://via.placeholder.com/150'
    },
  ];

  List<Map<String, dynamic>> _filteredProfiles = [];
=======
  List<DocumentSnapshot> _profiles = [];
  String _searchQuery = '';
>>>>>>> c5a32ebf57b097883c7cfb4e693e455543f1bb6b

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _filteredProfiles = _allProfiles;
  }

  void _filterProfiles() {
    setState(() {
      if (_profileSearchController.text.isEmpty) {
        _filteredProfiles = _allProfiles;
      } else {
        _filteredProfiles = _allProfiles.where((profile) {
          final name = profile['name']?.toLowerCase() ?? '';
          return name.contains(_profileSearchController.text.toLowerCase());
        }).toList();
      }
=======
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _profiles = querySnapshot.docs;
>>>>>>> c5a32ebf57b097883c7cfb4e693e455543f1bb6b
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _profileSearchController,
          decoration: InputDecoration(
<<<<<<< HEAD
            hintText: 'Search profiles...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            _filterProfiles();
=======
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
>>>>>>> c5a32ebf57b097883c7cfb4e693e455543f1bb6b
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
<<<<<<< HEAD
                hintText: 'Search...',
=======
                hintText: 'Search Profiles...',
>>>>>>> c5a32ebf57b097883c7cfb4e693e455543f1bb6b
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (query) {
<<<<<<< HEAD
                _filterProfiles();
=======
                setState(() {
                  _searchQuery = query;
                });
>>>>>>> c5a32ebf57b097883c7cfb4e693e455543f1bb6b
              },
            ),
          ),
          Expanded(
<<<<<<< HEAD
            child: _filteredProfiles.isEmpty
                ? Center(child: Text('No profiles found.'))
                : ListView.builder(
                    itemCount: _filteredProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = _filteredProfiles[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(profile['profilePicUrl']),
                        ),
                        title: Text(profile['name'] ?? 'No name'),
                      );
                    },
                  ),
=======
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
>>>>>>> c5a32ebf57b097883c7cfb4e693e455543f1bb6b
          ),
        ],
      ),
    );
  }
}
