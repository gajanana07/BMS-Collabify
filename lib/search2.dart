import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:classico/search3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Post',
      home: JobPostScreen(project: {
        'title': 'Designing an app',
        'description':
            'We are a young startup from Bangalore looking for a designer who can help us design a tech-oriented application. We are open to proposals.',
        'poster': 'Samraddhi',
        'date': '3 days ago',
        'skills': 'UX/UI, Design, Figma, Photoshop',
        'image':
            'https://images.unsplash.com/photo-1529626455594-4fcb2d6908e7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
        'category': 'UX/UI Design',
      }),
    );
  }
}

class JobPostScreen extends StatefulWidget {
  final Map<String, String> project;

  JobPostScreen({Key? key, required this.project}) : super(key: key);

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  int _selectedIndex = 1;

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
        // No change for dashboard, already on the home screen
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
      // Handle profile action here
    }
  }

  void _sendWorkPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApplicationForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project['title']!),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project['title']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Posted ${widget.project['date']}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              widget.project['description']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '10 propositions',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text('UX/UI')),
                SizedBox(width: 8),
                Chip(label: Text('DESIGN')),
                SizedBox(width: 8),
                Chip(label: Text('FIGMA')),
                SizedBox(width: 8),
                Chip(label: Text('PHOTOSHOP')),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _sendWorkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
