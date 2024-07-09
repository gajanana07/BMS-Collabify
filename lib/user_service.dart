import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUser(String uid) async {
    DocumentSnapshot userData =
        await _firestore.collection('users').doc(uid).get();
    if (userData.exists) {
      Map<String, dynamic> userDataMap =
          userData.data() as Map<String, dynamic>;
      String? profilePicture = userDataMap['profilePicture'];
      if (profilePicture != null && profilePicture.isNotEmpty) {
        try {
          String downloadUrl = await _storage
              .ref('user_images/$profilePicture')
              .getDownloadURL();
          userDataMap['profilePicture'] = downloadUrl;
        } catch (e) {
          // Handle errors like object not found
          print("Error fetching image URL: $e");
          userDataMap['profilePicture'] =
              ''; // Set to an empty string or a default value
        }
      } else {
        userDataMap['profilePicture'] =
            ''; // Default value if profilePicture is null or empty
      }
      return userDataMap;
    } else {
      return {};
    }
  }
}
