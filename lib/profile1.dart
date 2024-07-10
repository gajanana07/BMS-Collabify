import 'dart:io';
import 'dart:convert';

import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/login.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:classico/profile2.dart';
import 'package:classico/search.dart';
import 'package:classico/search3.dart';
import 'package:classico/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  User? _user;
  Future<Map<String, dynamic>>? _userDataFuture;
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userDataFuture = _userService.getUser(_user!.uid);
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user?.uid)
          .get();

      final data = snapshot.data() as Map<String, dynamic>;
      print('Fetched user data: $data');
      setState(() {
        _profileImageUrl = data['imageUrl'] ?? '';
        _userName = '${data['firstName']} ${data['lastName']}';
        _usn = data['usn'] ?? '';
        _email = data['email'] ?? '';
        _bio = data['bio'] ?? '';
        _skills = data['skills'] ?? '';
        _areaOfInterest = (data['interests'] as List<dynamic>).join(', ') ?? '';

        _githubLink = data['github'] ?? '';
        _resumeLink = data['resume'] ?? '';
      });
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProjectPage()),
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
        // Handle profile action here
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
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
              leading: Icon(Icons.interests, color: Colors.blue),
              title: Text('Area of Interest',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
              subtitle: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  var data = snapshot.data?.data() as Map<String, dynamic>?;
                  var interests = data?['interests'];
                  return interests != null && interests is List
                      ? Text((interests as List).join(', '))
                      : Text('Not provided');
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.code, color: Colors.blue),
              title: Text('GitHub',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
              subtitle:
                  Text(_githubLink.isEmpty ? 'Not provided' : _githubLink),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.blue),
              title: Text('Resume',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
              subtitle: _resumeLink.isEmpty
                  ? Text('Not provided')
                  : InkWell(
                      onTap: () async {
                        if (await canLaunch(_resumeLink)) {
                          await launch(_resumeLink);
                        } else {
                          throw 'Could not launch $_resumeLink';
                        }
                      },
                      child: Text(
                        'View Resume',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: _editResume,
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
        leading: Icon(Icons.edit, color: Colors.blue),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        subtitle: Text(content.isEmpty ? 'Not provided' : content),
        trailing: IconButton(
          icon: Icon(Icons.edit),
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
          title: Text('Edit Bio'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(labelText: 'Bio'),
                ),
                TextField(
                  controller: githubController,
                  decoration: InputDecoration(labelText: 'GitHub Link'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .update({
                  'bio': bioController.text,
                  'github': githubController.text,
                });
                setState(() {
                  _bio = bioController.text;
                  _githubLink = githubController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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
          title: Text('Edit Skills'),
          content: TextField(
            controller: skillsController,
            decoration: InputDecoration(labelText: 'Skills'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user?.uid)
                    .update({
                  'skills': skillsController.text,
                });
                setState(() {
                  _skills = skillsController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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

    if (result != null) {
      PlatformFile file = result.files.first;

      // Upload file to Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('resumes')
          .child('${_user?.uid}.pdf');
      UploadTask uploadTask = storageRef.putFile(File(file.path!));
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get file URL
      String resumeUrl = await taskSnapshot.ref.getDownloadURL();

      // Update user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user?.uid)
          .update({'resume': resumeUrl});

      setState(() {
        _resumeLink = resumeUrl;
      });
    }
  }

  Widget _buildProjectDetails() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
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
            stream: FirebaseFirestore.instance
                .collection(_selectedOption == 'Applied Projects'
                    ? 'applied_projects'
                    : 'projects')
                .where('email', isEqualTo: _user?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
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
                  return ListTile(
                    title: Text(data['project_name'] ?? 'No Project Name'),
                    subtitle: Text(data['project_tags'] ?? 'No Description'),
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
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: _userDataFuture != null
          ? FutureBuilder<Map<String, dynamic>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> userData = snapshot.data!;
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: _profileImageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        _profileImageUrl)
                                    : null,
                                child: _profileImageUrl.isEmpty
                                    ? Icon(Icons.account_circle, size: 100)
                                    : null,
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _userName,
                                    style: TextStyle(
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
                          tabs: [
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
                    return Center(child: Text('No data available'));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : Center(child: CircularProgressIndicator()),
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
        selectedItemColor: Color(0xFF009FFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
