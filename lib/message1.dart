import 'dart:io';
import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/profile1.dart';
import 'package:classico/search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FeedScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  FeedScreen({required this.selectedIndex, required this.onItemTapped});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _textController = TextEditingController();
  User? _user;
  String? _firstName;
  String? _profileImageUrl;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _onItemTapped(int index) {
    widget.onItemTapped(index); // Call the parent function to handle navigation

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
        // Handle message action here
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      final data = snapshot.data() as Map<String, dynamic>;
      print('Fetched user data: $data');
      setState(() {
        _firstName = data['firstName'];
        _profileImageUrl = data['imageUrl'];
        print(_firstName);
        print(_profileImageUrl);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_textController.text.isEmpty) return;

    try {
      String? imageUrl;

      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child('${DateTime.now().toIso8601String()}.jpg');

        // Uploading the file
        await storageRef.putFile(_image!);

        // Getting the download URL
        imageUrl = await storageRef.getDownloadURL();
      }

      // Adding post data to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'text': _textController.text,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(),
        'userProfileUrl': _profileImageUrl ?? 'https://via.placeholder.com/150',
        'username': _firstName ?? 'Anonymous',
        'likes': 0, // Initial likes count
        'likedBy': [], // Initialize as empty list
        'comments': [], // Empty array for comments
      });

      // Clear text input and reset image state
      _textController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      print('Error uploading post: $e');
      // Handle error as needed (e.g., show a snackbar or alert dialog)
    }
  }

  Future<void> _likePost(String postId) async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> likedBy = data['likedBy'] ?? [];
        int likes = data['likes'] ?? 0;

        if (likedBy.contains(_user!.uid)) {
          // If user already liked the post, remove like
          likedBy.remove(_user!.uid);
          likes--;
        } else {
          // If user hasn't liked the post, add like
          likedBy.add(_user!.uid);
          likes++;
        }

        transaction.update(postRef, {
          'likedBy': likedBy,
          'likes': likes,
        });
      });
    } catch (e) {
      print('Error liking post: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write something...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                /*IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),*/
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _uploadPost(); // Call the function correctly
                    if (_textController.text.isNotEmpty) {
                      _textController.clear();
                    }
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostItem(
                      postId: post.id,
                      username: post['username'],
                      userProfileUrl: post['userProfileUrl'],
                      timestamp: post['timestamp'].toDate().toString(),
                      text: post['text'],
                      imageUrl: post['imageUrl'],
                      likes: post['likes'],
                      comments: post['comments'],
                      onLike: () => _likePost(post.id),
                      likedBy: [],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped, // Use the local function to handle navigation
        selectedItemColor: Color(0xFF009FFF), // selected item color
        unselectedItemColor: Colors.grey, // unselected item color
        type: BottomNavigationBarType.fixed, // to show all items
      ),
    );
  }
}

class CommentsScreen extends StatefulWidget {
  final String postId;

  CommentsScreen({required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  User? _user;
  String? _firstName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      final data = snapshot.data() as Map<String, dynamic>;
      print('Fetched user data: $data');
      setState(() {
        _firstName = data['firstName'];

        print(_firstName);
      });
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.isEmpty || _user == null) return;

    print("this is in post comments : $_firstName");
    try {
      final commentData = {
        'text': _commentController.text,
        'timestamp': Timestamp.now(),
        'userId': _user!.uid,
        'username': _firstName ?? 'Anonymous',
      };

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add(commentData);

      _commentController.clear();
    } catch (e) {
      print('Error posting comment: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final data = comment.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['username']),
                      subtitle: Text(data['text']),
                      trailing: Text(
                        data['timestamp'].toDate().toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write a comment...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _postComment,
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostItem extends StatefulWidget {
  final String postId;
  final String username;
  final String userProfileUrl;
  final String timestamp;
  final String text;
  final String? imageUrl;
  final int likes;
  final List<dynamic> likedBy;
  final List<dynamic> comments;

  PostItem({
    required this.postId,
    required this.username,
    required this.userProfileUrl,
    required this.timestamp,
    required this.text,
    this.imageUrl,
    required this.likes,
    required this.likedBy,
    required this.comments,
    required Future<void> Function() onLike,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isLiked = false;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.likedBy.contains(FirebaseAuth.instance.currentUser!.uid);
    _likes = widget.likes;
  }

  Future<void> _toggleLike() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (_isLiked) {
      // Unlike the post
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
      setState(() {
        _isLiked = false;
        _likes -= 1;
      });
    } else {
      // Like the post
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
      setState(() {
        _isLiked = true;
        _likes += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.userProfileUrl),
            ),
            title: Text('${widget.username} @${widget.username}'),
            subtitle: Text('${widget.timestamp}\n\n${widget.text}'),
          ),
          if (widget.imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(widget.imageUrl!),
            ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      color: _isLiked ? Colors.blue : null,
                    ),
                    onPressed: _toggleLike,
                  ),
                  Text('$_likes'),
                ],
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(postId: widget.postId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              /*IconButton(
                icon: Icon(Icons.share),
                onPressed: () {},
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
