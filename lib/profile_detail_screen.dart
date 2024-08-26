import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> profile;

  const ProfileDetailsScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    String userName = '${profile['firstName']} ${profile['lastName']}';
    String usn = profile['usn'] ?? '';
    String email = profile['email'] ?? '';
    String bio = profile['bio'] ?? '';
    String skills = profile['skills'] ?? '';
    String githubLink = profile['github'] ?? '';
    String linkedInLink = profile['linkedIn'] ?? '';
    //String _resumeLink = profile['resume'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      ? const Icon(Icons.person, size: 100)
                      : null,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(usn),
                    Text(email),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAboutSection(bio, skills, githubLink, linkedInLink),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(
      String bio, String skills, String githubLink, String linkedInLink) {
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
              title: const Text(
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            child: ListTile(
              //leading: Icon(Icons.code, color: Colors.blue),
              title: const Text(
                'Linked In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle:
                  Text(linkedInLink.isEmpty ? 'Not provided' : linkedInLink),
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
            style: const TextStyle(
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
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0), // Adjust padding as needed
                      minimumSize: const Size(80, 35),
                    ),
                    child:
                        const Text('CONNECT', style: TextStyle(fontSize: 13)),
                  ),
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

class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? currentUserEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .where('client_email', isEqualTo: currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No projects found for this user.'));
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
