import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

import 'package:telechat/api/access_firebase_token.dart';
import 'package:telechat/models/Messages.dart';
import 'package:telechat/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  // for storing self information
  static ChatUser? me;

  // for getting firebase messaging token
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me!.pushToken = t;
        print('Push Token: $t');
      }
    });
    // for handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // For checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
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
      lastActive: DateTime.now().toString(), 
      pushToken: '',
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
        type: '',
        fromId: user.uid,
        sent: time);
    final ref =
        firestore.collection('chats/${getConversationID(chatuser.id)}/Messages/');
    await ref.doc().set(message.toJson()).then((value)=>sendPushNotification(chatuser, msg));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/Messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().toString()});
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

   // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me?.pushToken,
    });
  }

  // // for sending push notification
  // static Future<void> sendPushNotification( ChatUser chatUser, String msg) async {
  //   AccessFirebaseToken accessToken = AccessFirebaseToken();
  //   String bearerToken = await accessToken.getAccessToken();
  //   final body = {
  //   "message": {
  //   "token": chatUser.pushToken,
  //   "notification": {
  //   "title": chatUser.name,
  //   "body": msg,
  //   "android_channel_id":"chats"
  //   },
  //   }
  //   };
  //   try {
  //   var res = await post(
  //   Uri.parse('https://fcm.googleapis.com/v1/projects/telechat---chatapp/messages:send'),
  //   headers: {
  //   "Content-Type": "application/json",
  //   'Authorization': 'Bearer $bearerToken'
  //   },
  //   body: jsonEncode(body),
  //   );
  //   print("Response statusCode: ${res.statusCode}");
  //   print("Response body: ${res.body}");
  //   } catch (e) {
  //   print("\nsendPushNotification: $e");
  //   }
  //     }

    // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
      try {
      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me?.name, //our name should be send
            "body": msg,
          },
        }
      };
      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'telechat---chatapp';
      // get firebase admin token
      final bearerToken = await AccessFirebaseToken.getAccessToken;

      print('bearerToken: $bearerToken');

      // handle null token
      // ignore: unnecessary_null_comparison
      if (bearerToken == null) return;
      var res = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }

}
