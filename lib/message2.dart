import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:classico/search3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0;

  List<Message> messages = [
    Message(
        sender: "Rajkumar",
        text:
            "No problem Rajesh. I sent you the documents when I arrived at my office!"),
    Message(
        sender: "You",
        text:
            "I have received your documents. Maybe we can try another color for the homepage. I’m already working on a proposal. Also I see that the document has a lot of spelling mistakes. I correct everything that I see. I send you everything tomorrow."),
    Message(
        sender: "Rajkumar",
        text:
            "Nice! Sorry for the spelling mistakes, the text was pretty old."),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rajkumar'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.sender == "You";
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Send a message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
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

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}
