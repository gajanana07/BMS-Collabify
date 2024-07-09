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
      home: SendWorkPage(),
    );
  }
}

// ignore: must_be_immutable
class SendWorkPage extends StatelessWidget {
  int _selectedIndex = 0;

  SendWorkPage({super.key});

  void _onItemTapped(int index, BuildContext context) {
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
              onItemTapped: (index) =>
                  _onItemTapped(index, context), // Pass context here
            ),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text('Anthony'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Send your work',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Message',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Add your onPressed code here!
              },
              icon: Icon(Icons.upload_file),
              label: Text('Upload file'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[200],
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Github repo link',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Send',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        onTap: (index) {
          _onItemTapped(index, context); // Pass context here
        },
        selectedItemColor: Color(0xFF009FFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
