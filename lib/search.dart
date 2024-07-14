import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:classico/profileSearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allWorks = [];
  List<Map<String, dynamic>> _filteredWorks = [];
  List<String> _selectedCategories = [];
  int _selectedIndex = 1; // Default selected index for Search screen
  User? _user;
  String? _firstName;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchWorksFromFirestore();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      final data = snapshot.data() as Map<String, dynamic>;
      print('Fetched user data: $data');
      setState(() {
        _firstName = data['firstName'];
        _profileImageUrl = data['imageUrl'];
        print(_firstName);
        print(_profileImageUrl);
      });
    }
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
          'client_email': data['client_email'] ?? 'No email',
          'uploader_name': data['username'] ?? 'Unknown',
          'imageUrl': data['imageUrl'] ?? 'No image URL',
          'status': data['status'] ?? 'no status',
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
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 1:
        // Current screen, do nothing
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProjectPage()),
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
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProfileSearchScreen()), // profile search.
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                return ProjectCard(
                  project: work,
                  onTap: () => _navigateToJobPostScreen(work),
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
        selectedItemColor: const Color(0xFF009FFF), // selected item color
        unselectedItemColor: Colors.grey, // unselected item color
        type: BottomNavigationBarType.fixed, // to show all items
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: project['imageUrl'] != 'No image URL'
                        ? NetworkImage(project['imageUrl'])
                        : null,
                    backgroundColor: Colors.grey,
                    child: project['imageUrl'] == 'No image URL'
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['uploader_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const Text(
                        'Student',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  /*ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0), // Adjust padding as needed
                      minimumSize: Size(80, 35),
                    ),
                    child: Text('CONNECT', style: TextStyle(fontSize: 13)),
                  ),*/
                ],
              ),
              const SizedBox(height: 10),
              Text(
                project['project_name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(project['description'],
                  style: const TextStyle(
                    fontSize: 13,
                  )),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10.0,
                runSpacing: 4.0,
                children: (project['tags'] as String)
                    .split(',')
                    .map((tag) => Chip(
                          label: Text(
                            tag.trim(),
                            style: const TextStyle(
                              fontSize: 13.0, // Adjust font size here
                            ),
                          ),
                          backgroundColor: Colors.blue.shade100,
                          padding:
                              const EdgeInsets.all(4.0), // Adjust padding here
                          materialTapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // Reduce tap target size
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const FilterScreen({super.key, required this.selectedCategories});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> _categories = [];
  late List<String> _tempSelectedCategories;

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List<String>.from(widget.selectedCategories);
    _fetchTagsFromFirestore();
  }

  Future<List<String>> _fetchTagsFromFirestore() async {
    Set<String> tagsSet = {}; // Using a set to ensure uniqueness

    await FirebaseFirestore.instance
        .collection('projects')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String tagsString = doc['tags'];
        List<String> tags =
            tagsString.split(',').map((tag) => tag.trim()).toList();
        tagsSet.addAll(tags); // Adding tags to the set
      }
    });

    // Convert the set to a list
    List<String> tagsList = tagsSet.toList();

    // Ensure there are no duplicates in the final list
    List<String> uniqueTagsList = tagsList.toSet().toList();

    return uniqueTagsList;
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
      ),
    );
  }
}

class JobPostScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const JobPostScreen({super.key, required this.project});

  @override
  _JobPostScreenState createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  bool _hasApplied = false;
  bool _isUploader = false;
  final List<String> _appliedProjectIds = [];

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Check if the user is the uploader
      if (widget.project['client_email'] == user.email) {
        setState(() {
          _isUploader = true;
        });
        return;
      }

      // Check if the user has already applied for this specific project
      final QuerySnapshot applications = await firestore
          .collection('applications')
          .where('project_id', isEqualTo: widget.project['project_id'])
          .where('user_id', isEqualTo: user.uid)
          .get();

      if (applications.docs.isNotEmpty) {
        setState(() {
          _hasApplied = true;
          _appliedProjectIds.add(widget.project['project_id']);
        });
      }
    }
  }

  Future<void> _sendWorkViaGmail(
      String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
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

  Future<void> _sendNotification(String clientId, Map<String, dynamic> user,
      Map<String, dynamic> project) async {
    try {
      final notificationRef =
          FirebaseFirestore.instance.collection('notifications');

      // Check if the collection exists
      final docExists = await notificationRef.doc('dummyDoc').get();
      if (!docExists.exists) {
        // Create the collection by setting a dummy document
        await notificationRef.doc('dummyDoc').set({});
      }

      // Now add the notification document
      await notificationRef.add({
        'client_uid': clientId,
        'user': user,
        'project': project,
      });

      print('Notification sent successfully:');
      print('Client ID: $clientId');
      print('User data: $user');
      print('Project data: $project');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> _applyForProject() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String uid = user.uid;
      final DocumentSnapshot userData =
          await firestore.collection('users').doc(uid).get();

      if (userData.exists) {
        final String firstName = userData['firstName'];
        final String email = userData['email'];

        final Map<String, dynamic> userDataMap = {
          'first_name': firstName,
          'email': email,
        };

        print('user data : $firstName $email');

        final clientId = widget.project['client_email'];

        print('client email : $clientId');

        try {
          await _sendNotification(clientId, userDataMap, widget.project);
          print('Notification sent successfully.');

          // Store the application in Firestore
          await firestore.collection('applications').add({
            'project_id': widget.project['project_id'],
            'user_id': uid,
          });

          setState(() {
            _hasApplied = true;
            _appliedProjectIds.add(widget.project['project_id']);
          });

          // Update application status
          await _checkApplicationStatus();
        } catch (e) {
          print('Error sending notification: $e');
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
        title: Text(widget.project['project_name'] ?? 'No title'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Client',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.project['uploader_name'] ?? 'No username',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 15,
                indent: 15,
                endIndent: 15,
              ),
              const Text(
                'Client email',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.project['client_email'] ?? 'No description',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 15,
                indent: 15,
                endIndent: 15,
              ),
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.project['status'] ?? 'No status',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 15,
                indent: 15,
                endIndent: 15,
              ),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.project['description'] ?? 'No description',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 15,
                indent: 15,
                endIndent: 15,
              ),
              const Text(
                'Skills Required',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 10.0,
                children: (widget.project['tags'] ?? '')
                    .split(',')
                    .map<Widget>((tag) => Chip(
                          label: Text(tag.trim()),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blue.shade100,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 15,
                indent: 15,
                endIndent: 15,
              ),
              Text(
                'Posted On: ${widget.project['timestamp'] ?? 'No date'}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 15,
                indent: 15,
                endIndent: 15,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _appliedProjectIds
                              .contains(widget.project['project_id']) ||
                          _isUploader
                      ? null
                      : () async {
                          await _applyForProject();
                          final String clientEmail =
                              widget.project['client_email'] ??
                                  ''; // Fetch client's email from project
                          final String subject =
                              'Application for Project: ${widget.project['project_name'] ?? ''}';
                          const String body =
                              'hey! i would love to collaborate with you for the above mentioned project. here are my details.';

                          await _sendWorkViaGmail(clientEmail, subject, body);
                        },
                  child: Text(
                      _appliedProjectIds.contains(widget.project['project_id'])
                          ? 'Already Applied'
                          : _isUploader
                              ? 'You are the uploader'
                              : 'Apply for project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
