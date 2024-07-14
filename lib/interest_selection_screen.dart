import 'package:flutter/material.dart';
import 'package:classico/complete_profile_screen.dart';

class InterestSelectionScreen extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const InterestSelectionScreen({super.key, 
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  _InterestSelectionScreenState createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final List<String> _interests = [
    'Technology',
    'Data Science',
    'Machine Learning',
    'Web Dev',
    'App Development',
    'Ethical Hacking',
    'Game Development',
    'Cybersecurity'
  ];
  final List<String> _selectedInterests = [];

  void _navigateToCompleteProfile() {
    if (_selectedInterests.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 3 interests.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteProfileScreen(
          username: widget.username,
          email: widget.email,
          password: widget.password,
          interests: _selectedInterests,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Interests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _interests.length,
                itemBuilder: (context, index) {
                  String interest = _interests[index];
                  return CheckboxListTile(
                    title: Text(interest),
                    value: _selectedInterests.contains(interest),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToCompleteProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
