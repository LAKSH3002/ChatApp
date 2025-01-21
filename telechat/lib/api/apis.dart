import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telechat/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  // for storing self information
  static late ChatUser me;

  // For checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(user.uid)
            .get())
        .exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async{
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if(user.exists){
        me = ChatUser.fromJson(user.data()!);
        print('My Data: ${user.data()}');
      }
      else{
        await createuser().then((value)=>getSelfInfo());
      }
    });
  }

  // For creating a new user
  static Future<void> createuser() async 
  {
    // Video 20 for date and time
    final Chatuser = ChatUser(
        lastActive: user.toString(),
        createdAt: user.toString(),
        about: user.toString(),
        id: user.uid.toString(),
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        email: user.email.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(Chatuser.toJson());
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }

  // for updating user information
    static Future<void> updateUserInfo() async {
    await firestore
            .collection('users')
            .doc(user.uid)
            .update({
              'name': me.name,
              'about': me.about
            });
  }
}
