import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> profile;

  const ProfileDetailsScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _userName = '${profile['firstName']} ${profile['lastName']}';
    String _usn = profile['usn'] ?? '';
    String _email = profile['email'] ?? '';
    String _bio = profile['bio'] ?? '';
    String _skills = profile['skills'] ?? '';
    String _githubLink = profile['github'] ?? '';
    //String _resumeLink = profile['resume'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile['imageUrl'] != null
                      ? CachedNetworkImageProvider(profile['imageUrl'])
                      : null,
                  child: profile['imageUrl'] == null
                      ? Icon(Icons.person, size: 100)
                      : null,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _userName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(_usn),
                    Text(_email),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildAboutSection(_bio, _skills, _githubLink),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(String bio, String skills, String githubLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditableSection(
          title: 'Bio',
          content: bio,
          // You can add edit functionality here if needed
        ),
        _buildEditableSection(
          title: 'Skills',
          content: skills,
          // You can add edit functionality here if needed
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            child: ListTile(
              //leading: Icon(Icons.code, color: Colors.blue),
              title: Text(
                'GitHub',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: Text(githubLink.isEmpty ? 'Not provided' : githubLink),
            ),
          ),
        ),

        /*Card(
          child: ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.blue),
            title: Text(
              'Resume',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            subtitle: resumeLink.isEmpty
                ? Text('Not provided')
                : InkWell(
                    onTap: () async {
                      // Implement functionality to view resume
                    },
                    child: Text(
                      'View Resume',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
          ),
        ),*/
      ],
    );
  }

  Widget _buildEditableSection({
    required String title,
    required String content,
    // You can add edit functionality here if needed
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          subtitle: Text(content.isEmpty ? 'Not provided' : content),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onTap;

  const ProjectCard({required this.project, required this.onTap});

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
                        ? Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['uploader_name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Student',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
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
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                project['project_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              Text(project['description'],
                  style: TextStyle(
                    fontSize: 13,
                  )),
              SizedBox(height: 15),
              Wrap(
                spacing: 10.0,
                runSpacing: 4.0,
                children: (project['tags'] as String)
                    .split(',')
                    .map((tag) => Chip(
                          label: Text(
                            tag.trim(),
                            style: TextStyle(
                              fontSize: 13.0, // Adjust font size here
                            ),
                          ),
                          backgroundColor: Colors.blue.shade100,
                          padding: EdgeInsets.all(4.0), // Adjust padding here
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

class ProjectsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? currentUserEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .where('client_email', isEqualTo: currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No projects found for this user.'));
          }

          var projects = snapshot.data!.docs;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index].data() as Map<String, dynamic>;
              return ProjectCard(
                project: project,
                onTap: () {
                  // Handle onTap action if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
