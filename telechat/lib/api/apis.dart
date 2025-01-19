import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telechat/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  // For checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // For creating a new user
  static Future<void> createuser() async 
  {
    // Video 20 for date and time
    final Chatuser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        email: user.email.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(Chatuser.toJson());
  }
}
