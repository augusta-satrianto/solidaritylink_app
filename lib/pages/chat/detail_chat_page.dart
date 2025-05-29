import 'dart:io';

import 'package:solidaritylink_app/data/dummy_message.dart';
import 'package:solidaritylink_app/data/dummy_users.dart';
import 'package:solidaritylink_app/models/message_model.dart';
import 'package:solidaritylink_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailPage extends StatefulWidget {
  final int senderId;
  final UserModel receiver;

  const ChatDetailPage({
    super.key,
    required this.senderId,
    required this.receiver,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  int? _editingMessageId;
  int? _replyingMessageId;
  final ImagePicker _picker = ImagePicker();

  void _sendMessage({String? imagePath}) {
    FocusScope.of(context).requestFocus(FocusNode());
    final text = _controller.text.trim();
    if (text.isEmpty && imagePath == null) return;

    if (_editingMessageId != null) {
      // Edit mode
      final idx = dummyMessages.indexWhere((m) => m.id == _editingMessageId);
      if (idx != -1) {
        setState(() {
          dummyMessages[idx].text = text;
          dummyMessages[idx].imagePath = imagePath;
          dummyMessages[idx].time = DateTime.now();
        });
      }
      _editingMessageId = null;
    } else {
      // Add new
      setState(() {
        dummyMessages.add(
          MessageModel(
            id: DateTime.now().millisecondsSinceEpoch,

            senderId: widget.senderId,
            receiverId: widget.receiver.id,
            text: text,
            imagePath: imagePath,
            time: DateTime.now(),
            replyToId: _replyingMessageId,
          ),
        );
      });
    }

    _controller.clear();
    _replyingMessageId = null;
  }

  void _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _sendMessage(imagePath: picked.path);
    }
  }

  void _startEdit(MessageModel msg) {
    setState(() {
      _editingMessageId = msg.id;
      _controller.text = msg.text;
      _replyingMessageId = null;
    });
  }

  void _deleteMessage(MessageModel msg) {
    setState(() {
      dummyMessages.removeWhere((m) => m.id == msg.id);
      if (_editingMessageId == msg.id) _editingMessageId = null;
      if (_replyingMessageId == msg.id) _replyingMessageId = null;
    });
  }

  void _startReply(MessageModel msg) {
    setState(() {
      _replyingMessageId = msg.id;
      _editingMessageId = null;
      _controller.clear();
    });
  }

  String getRepliedUserName(int replyToId) {
    final repliedMsg = dummyMessages.firstWhere((m) => m.id == replyToId);

    final user = dummyUsers.firstWhere((u) => u.id == repliedMsg.senderId);

    return user.name;
  }

  Widget _buildMessageTile(MessageModel msg) {
    final replyMsg =
        msg.replyToId != null
            ? dummyMessages.firstWhere(
              (m) => m.id == msg.replyToId,
              orElse:
                  () => MessageModel(
                    id: 0,
                    senderId: widget.senderId,
                    receiverId: widget.receiver.id,
                    text: '[Pesan dihapus]',
                    time: DateTime.now(),
                  ),
            )
            : null;

    bool isMyMessage = msg.senderId == widget.senderId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyMessage)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'reply') _startReply(msg);
              },
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: 'reply', child: Text('Reply')),
                  ],
            ),

          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMyMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMyMessage ? const Color(0xFF5F8D5A) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          isMyMessage
                              ? const Radius.circular(16)
                              : const Radius.circular(0),
                      bottomRight:
                          isMyMessage
                              ? const Radius.circular(0)
                              : const Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (replyMsg != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0x50FFFFFF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  width: 2,
                                  color:
                                      isMyMessage
                                          ? const Color(0xFF5F8D5A)
                                          : Colors.grey.shade200,
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getRepliedUserName(msg.replyToId!),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      replyMsg.text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (replyMsg.imagePath != null)
                                      Image.file(
                                        File(replyMsg.imagePath!),
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (msg.text.isNotEmpty)
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: isMyMessage ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      if (msg.imagePath != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Column(
                            children: [
                              Image.file(
                                File(msg.imagePath!),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        msg.time.toLocal().toString().substring(11, 16),
                        style: TextStyle(
                          color: isMyMessage ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isMyMessage)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') _startEdit(msg);
                if (value == 'delete') _deleteMessage(msg);
                if (value == 'reply') _startReply(msg);
              },
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                    PopupMenuItem(value: 'reply', child: Text('Reply')),
                  ],
            ),
        ],
      ),
    );
  }

  Widget _buildReplyBanner() {
    if (_replyingMessageId == null) return const SizedBox.shrink();

    final replyMsg = dummyMessages.firstWhere(
      (m) => m.id == _replyingMessageId,
      orElse:
          () => MessageModel(
            id: 0,
            senderId: widget.senderId,
            receiverId: widget.receiver.id,
            text: '[Pesan dihapus]',
            time: DateTime.now(),
          ),
    );

    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            'Replying to: ${replyMsg.text}',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          if (replyMsg.imagePath != null)
            Image.file(
              File(replyMsg.imagePath!),
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _replyingMessageId = null;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final relevantMessages =
        dummyMessages
            .where(
              (msg) =>
                  (msg.senderId == widget.senderId &&
                      msg.receiverId == widget.receiver.id) ||
                  (msg.senderId == widget.receiver.id &&
                      msg.receiverId == widget.senderId),
            )
            .toList();

    return Scaffold(
      backgroundColor: Color(0xFFE9EAEB),
      appBar: AppBar(
        title: const Text('Pesan'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              spacing: 16,
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundImage:
                      widget.receiver.image != null
                          ? FileImage(File(widget.receiver.image!))
                          : const AssetImage('assets/img_profile.webp'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      widget.receiver.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    // Text(
                    //   '(+62) 50 9285 3022',
                    //   style: TextStyle(fontSize: 12, color: Color(0xFF686A8A)),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: relevantMessages.length,
              itemBuilder: (context, index) {
                final msg =
                    relevantMessages[relevantMessages.length - 1 - index];
                return _buildMessageTile(msg);
              },
            ),
          ),

          _buildReplyBanner(),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add), onPressed: _pickImage),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText:
                          _editingMessageId != null
                              ? 'Edit pesan'
                              : (_replyingMessageId != null
                                  ? 'Balas pesan'
                                  : 'Ketik pesan...'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true, // Aktifkan background
                      fillColor: Colors.grey[200], // Warna latar belakang
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
