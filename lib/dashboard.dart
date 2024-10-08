// dashboard.dart

import 'package:classico/addProject.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:flutter/material.dart';
import 'package:classico/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _appliedProjects = [];
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchAppliedProjectsFromFirestore();
    _fetchUserNameFromFirestore();
  }

  void _fetchAppliedProjectsFromFirestore() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Fetching applied projects for user: ${user.email}');
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('applied_projects')
            .where('email', isEqualTo: user.email)
            .get();

        final List<Map<String, dynamic>> projects = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print('Fetched project: $data');
          return {
            'project_name': data['project_name'] ?? 'No title',
            'description': data['project_description'] ?? 'No description',
            'tags': data['project_tags'] ?? 'No tags',
            'timestamp':
                data['project_timestamp'], // Directly store the Timestamp
            'client_email': data['client_email'] ?? 'No client email',
            'client_id': data['client_id'] ?? '',
            'project_status': data['project_status'] ?? 'No status',
          };
        }).toList();

        setState(() {
          _appliedProjects = projects;
          print('Applied projects set: $_appliedProjects');
        });
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching applied projects from Firestore: $e');
      // Handle error appropriately here
    }
  }

  void _fetchUserNameFromFirestore() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Fetching user name for user: ${user.uid}');
        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = snapshot.data() as Map<String, dynamic>;
        print('Fetched user data: $data');
        setState(() {
          _userName = data['firstName'] ?? 'Unknown';
        });
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching user name from Firestore: $e');
      // Handle error appropriately here
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // No change for dashboard, already on the Dashboard screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProjectPage()),
        );
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
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  void _onProjectTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProjectDetailsScreen(project: _appliedProjects[index]),
      ),
    );
  }

  Future<void> _sendWorkViaGmail(
      String email, String subject, String body) async {
    final Uri gmailUri = Uri(
      scheme: 'https',
      path: 'mail.google.com/mail/u/0/',
      queryParameters: {
        'view': 'cm',
        'fs': '1',
        'to': email,
        'su': subject,
        'body': body,
      },
    );

    if (await canLaunch(gmailUri.toString())) {
      await launch(gmailUri.toString());
    } else {
      throw 'Could not launch $gmailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_userName!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Applied Projects',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _appliedProjects.length,
                itemBuilder: (context, index) {
                  final project = _appliedProjects[index];
                  return GestureDetector(
                    onTap: () {
                      _onProjectTapped(index);
                    },
                    child: ProjectCard(project: project),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF009FFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectCard({super.key, required this.project});

  String _getShortDescription(String description) {
    const int maxLength = 50;
    if (description.length <= maxLength) {
      return description;
    } else {
      return '${description.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'No date';
    if (project['timestamp'] is String) {
      String timestampStr = project['timestamp'] as String;
      formattedDate = timestampStr.split(' ')[0];
    } else {
      print("Timestamp is not a valid String: ${project['timestamp']}");
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project['project_name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(_getShortDescription(project['description'])),
            const SizedBox(height: 8.0),
            Text(
              project['tags'],
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              formattedDate,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  ProjectDetailsScreen({super.key, required this.project}) {
    // Print the project details to verify the data
    print('Project details: $project');
  }

  Future<void> _sendWorkViaGmail(
      String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      /*queryParameters: {
        'subject': subject,
        'body': body,
      },*/
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project['project_name'] ?? 'No title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Project Name',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                project['project_name'] ?? 'No title',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Client Email',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                project['client_email'] ?? 'No client email',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Status',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                project['project_status'] ?? 'No status',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Description',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(project['description'] ?? 'No description'),
              const SizedBox(height: 8.0),
              const Text(
                'Posted On',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(project['timestamp'] ?? 'No date'),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final String clientEmail = project['client_email'] ??
                        ''; // Fetch client's email from project
                    final String subject =
                        'Application for Project: ${project['project_name'] ?? ''}';
                    const String body =
                        'Here are the files which you have asked for';

                    await _sendWorkViaGmail(clientEmail, subject, body);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  ),
                  child: const Text('Send Your Work'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
