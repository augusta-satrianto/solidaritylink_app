// import 'dart:io';

// import 'package:solidaritylink_app/data/dummy_message.dart';
// import 'package:solidaritylink_app/data/dummy_users.dart';
// import 'package:solidaritylink_app/models/message_model.dart';
// import 'package:solidaritylink_app/models/user_model.dart';
// import 'package:solidaritylink_app/pages/chat/detail_chat_page.dart';
// import 'package:solidaritylink_app/services/auth_service.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   // Ambil pesan terakhir antara user login dan user lain
//   MessageModel? getLastMessageForUser(int currentUserId, int userId) {
//     final messages = dummyMessages.where(
//       (msg) =>
//           (msg.senderId == currentUserId && msg.receiverId == userId) ||
//           (msg.senderId == userId && msg.receiverId == currentUserId),
//     );

//     if (messages.isEmpty) return null;

//     return messages.reduce((a, b) => a.time.isAfter(b.time) ? a : b);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final userAuth = Session().currentUser;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Pesan'),
//         backgroundColor: Colors.green[400],
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(24),
//         itemCount: dummyUsers.length,
//         itemBuilder: (context, index) {
//           UserModel user = dummyUsers[index];

//           if (user.id == userAuth?.id) return const SizedBox.shrink();

//           final lastMsg = getLastMessageForUser(userAuth!.id, user.id);

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 24),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) => ChatDetailPage(
//                           senderId: userAuth.id,
//                           receiver: user,
//                         ),
//                   ),
//                 ).then((_) => setState(() {}));
//               },
//               child: Container(
//                 color: Colors.white,
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 21,
//                       backgroundImage:
//                           user.image != null
//                               ? FileImage(File(user.image!))
//                               : const AssetImage('assets/img_profile.webp'),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   user.name,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               if (lastMsg != null)
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 16),
//                                   child: Text(
//                                     lastMsg.time.toLocal().toString().substring(
//                                       11,
//                                       16,
//                                     ),
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   lastMsg == null
//                                       ? 'Mulai obrolan...'
//                                       : (lastMsg.imagePath != null &&
//                                               lastMsg.text.isEmpty
//                                           ? 'Gambar'
//                                           : lastMsg.text),
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.push(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => KontakPage()),
//       //     );
//       //   },
//       //   backgroundColor: Colors.green,
//       //   tooltip: 'Tambah Chat',
//       //   elevation: 0,
//       //   child: const Icon(Icons.add_comment, color: Colors.white),
//       // ),
//     );
//   }
// }
