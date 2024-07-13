import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _handleNotification(String notificationId, bool accepted) async {
    final notificationRef = FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId);

    final notificationData = await notificationRef.get();
    final projectData = notificationData['project'];
    final userData = notificationData['user'];

    if (accepted) {
      final appliedProjectsRef =
          FirebaseFirestore.instance.collection('applied_projects');
      await appliedProjectsRef.add({
        'first_name': userData['first_name'],
        'email': userData['email'],
        'username': projectData['username'],
        'client_email': projectData['client_email'],
        'project_name': projectData['project_name'],
        'project_description': projectData['description'],
        'project_tags': projectData['tags'],
        'project_timestamp': projectData['timestamp'],
        'project_status': projectData['status'],
      });
    }

    await notificationRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('client_uid',
                isEqualTo: _user?.email) // Filter by current user's email
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final notificationData =
                  notification.data() as Map<String, dynamic>;
              final user = notificationData['user'];
              final project = notificationData['project'];
              print('user $user , project : $project');
              return ListTile(
                title: Text(
                  '${user['first_name']} wants to work on ${project['project_name']}',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _handleNotification(notification.id, true),
                        child: Text('Accept'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _handleNotification(notification.id, false),
                        child: Text('reject'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
