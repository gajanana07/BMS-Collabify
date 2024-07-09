import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allWorks = [];

  List<Map<String, dynamic>> _filteredWorks = [];
  List<String> _selectedCategories = [];
  int _selectedIndex = 1; // Default selected index for Search screen

  @override
  void initState() {
    super.initState();
    _fetchWorksFromFirestore();
  }

  void _fetchWorksFromFirestore() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('projects').get();

      final List<Map<String, dynamic>> works = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'project_name': data['project_name'] ?? 'No title',
          'description': data['description'] ?? 'No description',
          'tags': data['tags'] ?? 'No tags',
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate().toString() ??
              'No date',
          'email': data['email'] ?? 'No email',
        };
      }).toList();

      setState(() {
        _allWorks = works;
        _filteredWorks = works;
      });
    } catch (e) {
      print('Error fetching works from Firestore: $e');
      // Handle error appropriately here
    }
  }

  void _filterWorks() {
    setState(() {
      if (_searchController.text.isEmpty && _selectedCategories.isEmpty) {
        _filteredWorks = _allWorks;
      } else {
        _filteredWorks = _allWorks.where((work) {
          final projectName = work['project_name'] ?? '';
          final description = work['description'] ?? '';
          final tags =
              (work['tags'] ?? '').split(',').map((tag) => tag.trim()).toList();

          final matchesQuery = _searchController.text.isEmpty ||
              projectName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              description
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              tags.any((tag) => tag
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()));

          final matchesCategory = _selectedCategories.isEmpty ||
              _selectedCategories.any((category) => tags.contains(category));

          return matchesQuery && matchesCategory;
        }).toList();
      }
    });
  }

  void _showFilters() async {
    final selectedCategories = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilterScreen(selectedCategories: _selectedCategories),
      ),
    );
    if (selectedCategories != null) {
      setState(() {
        _selectedCategories = List<String>.from(selectedCategories);
      });
      _filterWorks();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        break;
      case 1:
        // Current screen, do nothing
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProjectPage()),
        );
        // Handle add action here
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FeedScreen(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onItemTapped,
                  )),
        );
        // Handle message action here
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        // Handle profile action here
        break;
    }
  }

  void _navigateToJobPostScreen(Map<String, dynamic> project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobPostScreen(project: project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (query) {
                _filterWorks();
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters'),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilters,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredWorks.length,
              itemBuilder: (context, index) {
                final work = _filteredWorks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(work['project_name'] ?? 'No title'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(work['timestamp'] ?? 'No date'),
                        Text(work['tags'] ??
                            'No tags'), // New line to display tags
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _navigateToJobPostScreen(work);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '', // Set label to an empty string
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF009FFF), // selected item color
        unselectedItemColor: Colors.grey, // unselected item color
        type: BottomNavigationBarType.fixed, // to show all items
      ),
    );
  }
}

class FilterScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const FilterScreen({Key? key, required this.selectedCategories})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> _categories = [];
  late List<String> _tempSelectedCategories;

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List<String>.from(widget.selectedCategories);
    _fetchTagsFromFirestore();
  }

  Future<List<String>> _fetchTagsFromFirestore() async {
    List<String> tags = [];
    await FirebaseFirestore.instance
        .collection('projects')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        tags.add(doc['tags']);
      });
    });
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filters'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _tempSelectedCategories);
              },
              child: const Text(
                'APPLY',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<String>>(
          future: _fetchTagsFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching tags'));
            } else {
              return ListView(
                children: snapshot.data!.map((tag) {
                  return CheckboxListTile(
                    title: Text(tag),
                    value: _tempSelectedCategories.contains(tag),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _tempSelectedCategories.add(tag);
                        } else {
                          _tempSelectedCategories.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }
          },
        ));
  }
}

class JobPostScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const JobPostScreen({Key? key, required this.project}) : super(key: key);

  Future<void> _sendWorkViaGmail(
      String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      if (await canLaunch(emailUri.toString())) {
        await launch(emailUri.toString());
      } else {
        throw 'Could not launch $emailUri';
      }
    } catch (e) {
      print(e);
    }
  }

  void _launchGmail(
      {required String toEmail,
      required String subject,
      required String body}) async {
    final Uri gmailUri = Uri(
      scheme: 'https',
      path: 'mail.google.com/mail/u/0/',
      queryParameters: {
        'view': 'cm',
        'fs': '1',
        'to': toEmail,
        'su': subject,
        'body': body,
      },
    );

    // ignore: deprecated_member_use
    if (await canLaunch(gmailUri.toString())) {
      // ignore: deprecated_member_use
      await launch(gmailUri.toString());
    } else {
      throw 'Could not launch $gmailUri';
    }
  }

  Future<void> _applyForProject() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _appliedProjectsCollection =
        _firestore.collection('applied_projects');

    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;
      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();

      if (userData.exists) {
        final String firstName = userData['firstName'];
        final String email = userData['email'];

        final Map<String, dynamic> applicationData = {
          'first_name': firstName,
          'email': email,
          'project_name': project['project_name'],
          'project_description': project['description'],
          'project_tags': project['tags'],
          'project_timestamp': project['timestamp'],
        };

        try {
          await _appliedProjectsCollection.add(applicationData);
          print('Application data added to applied_projects collection');
        } catch (e) {
          print('Error adding application data: $e');
        }
      } else {
        print('User data not found');
      }
    } else {
      print('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project['project_name'] ?? 'No title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(project['description'] ?? 'No description'),
            const SizedBox(height: 16.0),
            const Text(
              'Skills Required',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(project['tags'] ?? 'No tags'),
            const SizedBox(height: 16.0),
            const Text(
              'Posted On',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(project['timestamp'] ?? 'No date'),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final String email = project['email'] ?? '';
                  final String subject =
                      'Application for Project: ${project['project_name'] ?? ''}';
                  final String body =
                      'I would love to work with you on this project.';

                  await _applyForProject();
                  _sendWorkViaGmail(email, subject, body);
                },
                child: Text('Apply for job'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
