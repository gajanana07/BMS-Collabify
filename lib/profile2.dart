import 'package:classico/dashboard.dart';
import 'package:classico/search.dart';
import 'package:flutter/material.dart';
import 'package:classico/addProject.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:classico/profile2.dart';
import 'package:classico/search3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReviewsPage(),
    );
  }
}

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ReviewItem(
            name: 'Rahul',
            date: '05/03/2024',
            review: 'Awesome job!',
            rating: 5,
          ),
          ReviewItem(
            name: 'Simran',
            date: '02/03/2024',
            review:
                'Rajesh is a very great designer, having a lot of positive energy with him!',
            rating: 4,
          ),
          ReviewItem(
            name: 'Akshay',
            date: '17/02/2024',
            review:
                'Working with Rajesh is always a pleasure! He has limitless capabilities!',
            rating: 5,
          ),
          ReviewItem(
            name: 'Anshuman',
            date: '19/01/2024',
            review:
                'I recommend Rajesh. Always impress by his work and his speed!',
            rating: 4,
          ),
        ],
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
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF009FFF), // selected item color
        unselectedItemColor: Colors.grey, // unselected item color
        type: BottomNavigationBarType.fixed, // to show all items
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String name;
  final String date;
  final String review;
  final int rating;

  ReviewItem({
    required this.name,
    required this.date,
    required this.review,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            review,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Rating',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 8),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.blue,
                    size: 20,
                  );
                }),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
