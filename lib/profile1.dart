import 'dart:io';

import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/notification_screen.dart';
import 'package:classico/message1.dart';
import 'package:classico/search.dart';
import 'package:classico/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  User? _user;
  Future<DocumentSnapshot<Map<String, dynamic>>>? _userDataFuture;
  int _selectedIndex = 4;
  String _selectedOption = 'Applied Projects';
  late TabController _tabController;
  String _profileImageUrl = '';
  String _userName = '';
  String _usn = '';
  String _email = '';
  String _bio = '';
  String _skills = '';
  String _areaOfInterest = '';
  String _githubLink = '';
  String _resumeLink = '';
  String _linkedInLink = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userDataFuture =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();

      _userDataFuture!.then((snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data()!;
          setState(() {
            _profileImageUrl = data['imageUrl'] ?? '';
            _userName = '${data['firstName']} ${data['lastName']}';
            _usn = data['usn'] ?? '';
            _email = data['email'] ?? '';
            _bio = data['bio'] ?? '';
            _skills = data['skills'] ?? '';
            _areaOfInterest =
                (data['interests'] as List<dynamic>).join(', ') ?? '';
            _githubLink = data['github'] ?? '';
            _resumeLink = data['resume'] ?? '';
          });
        }
      }).catchError((error) {
        print('Error fetching user data: $error');
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AddProjectPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FeedScreen(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onItemTapped,
                  )),
        );
        break;
      case 4:
        // Handle profile action here
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildEditableSection(
            title: 'Bio',
            content: _bio,
            onEdit: _editBio,
          ),
          _buildEditableSection(
            title: 'Skills',
            content: _skills,
            onEdit: _editSkills,
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.interests, color: Colors.blue),
              title: const Text(
                'Area of Interest',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }
                  var data =
                      snapshot.data?.data() as Map<String, dynamic>? ?? {};
                  var interests = data['interests'];
                  return interests != null && interests is List
                      ? Text(interests.join(', '))
                      : const Text('Not provided');
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: const Text(
                'GitHub',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle:
                  Text(_githubLink.isEmpty ? 'Not provided' : _githubLink),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link, color: Colors.blue),
              title: const Text(
                'LinkedIn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle:
                  Text(_linkedInLink.isEmpty ? 'Not provided' : _linkedInLink),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editLinkedIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSection({
    required String title,
    required String content,
    required Function() onEdit,
  }) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.edit, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        subtitle: Text(content.isEmpty ? 'Not provided' : content),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }

  void _editBio() {
    final TextEditingController bioController =
        TextEditingController(text: _bio);
    final TextEditingController githubController =
        TextEditingController(text: _githubLink);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Bio'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                TextField(
                  controller: githubController,
                  decoration: const InputDecoration(labelText: 'GitHub Link'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .update({
                  'bio': bioController.text,
                  'github': githubController.text,
                }).then((value) {
                  setState(() {
                    _bio = bioController.text;
                    _githubLink = githubController.text;
                  });
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to update bio: $error');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update bio')),
                  );
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editSkills() {
    final TextEditingController skillsController =
        TextEditingController(text: _skills);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Skills'),
          content: TextField(
            controller: skillsController,
            decoration: const InputDecoration(labelText: 'Skills'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .update({
                  'skills': skillsController.text,
                }).then((value) {
                  setState(() {
                    _skills = skillsController.text;
                  });
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to update skills: $error');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update skills')),
                  );
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // Upload file to Firebase Storage
      String resumeUrl = await _uploadResumeFile(file, fileName);

      // Update Firestore with the new resume URL
      FirebaseFirestore.instance.collection('users').doc(_user?.uid).update({
        'resume': resumeUrl,
      }).then((value) {
        setState(() {
          _resumeLink = resumeUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume uploaded successfully')),
        );
      }).catchError((error) {
        print('Failed to upload resume: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload resume')),
        );
      });
    }
  }

  Future<String> _uploadResumeFile(File file, String fileName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('resumes').child(_user!.uid).child(fileName);
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading resume: $e');
      return '';
    }
  }

  void _editLinkedIn() {
    final TextEditingController linkedInController =
        TextEditingController(text: _linkedInLink);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit LinkedIn Link'),
          content: TextField(
            controller: linkedInController,
            decoration: const InputDecoration(labelText: 'LinkedIn Link'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .update({
                  'linkedIn': linkedInController.text,
                }).then((value) {
                  setState(() {
                    _linkedInLink = linkedInController.text;
                  });
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to update LinkedIn link: $error');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update LinkedIn link')),
                  );
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectDetails() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            value: _selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue!;
              });
            },
            items: <String>['Applied Projects', 'Uploaded Projects']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _selectedOption == 'Applied Projects'
                ? FirebaseFirestore.instance
                    .collection('applied_projects')
                    .where('email', isEqualTo: _user?.email)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('projects')
                    .where('client_email', isEqualTo: _user?.email)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var documents = snapshot.data!.docs;
              print('Fetched documents: ${documents.length}');
              for (var doc in documents) {
                print('Document data: ${doc.data()}');
              }
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var data = documents[index].data() as Map<String, dynamic>;
                  print('Building ListTile for: $data');
                  /*return ListTile(
                    title: Text(data['project_name'] ?? 'No Project Name'),
                    subtitle: _selectedOption == 'Applied Projects'
                        ? Text(data['project_tags'] ?? 'No Description')
                        : Text(data['tags'] ?? 'No Description'),
                  );*/
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          data['project_name'] ?? 'No Project Name',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: _selectedOption == 'Applied Projects'
                            ? Text(data['project_tags'] ?? 'No Description')
                            : Text(data['tags'] ?? 'No Description'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: _userDataFuture != null
          ? FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data()!;
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: _profileImageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        _profileImageUrl)
                                    : null,
                                child: _profileImageUrl.isEmpty
                                    ? const Icon(Icons.account_circle, size: 100)
                                    : null,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(_usn),
                                  Text(_email),
                                ],
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'About'),
                            Tab(text: 'Projects'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildAboutSection(),
                              _buildProjectDetails(),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
