import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telechat/models/Messages.dart';
import 'package:telechat/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  // for storing self information
  static ChatUser? me;

  // For checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        print('My Data: ${user.data()}');
      } else {
        await createuser().then((value) => getSelfInfo());
      }
    });
  }

  // For creating a new user
  static Future<void> createuser() async {
    // Video 20 for date and time
    final Chatuser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      image: user.photoURL.toString(),
      about: 'Hey there! I am using TeleChat.',
      createdAt: DateTime.now().toString(),
      lastActive: DateTime.now().toString(),
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(Chatuser.toJson());
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me!.name, 'about': me!.about});
  }

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMsg(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/Messages/')
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(ChatUser chatuser, String msg) async {
    // message sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to send
    final Messages message = Messages(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: 'text',
        fromId: user.uid,
        sent: time);
    final ref =
        firestore.collection('chats/${getConversationID(chatuser.id)}/Messages/');
    await ref.doc().set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/Messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
