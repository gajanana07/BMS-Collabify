import 'package:flutter/material.dart';

class ProfileSearchScreen extends StatefulWidget {
  const ProfileSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSearchScreen> createState() => _ProfileSearchScreenState();
}

class _ProfileSearchScreenState extends State<ProfileSearchScreen> {
  final TextEditingController _profileSearchController =
      TextEditingController();
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

  @override
  void initState() {
    super.initState();
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
    });
  }

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
            _filterProfiles();
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
              onChanged: (query) {
                _filterProfiles();
              },
            ),
          ),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
