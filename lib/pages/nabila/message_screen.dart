import 'package:flutter/material.dart';
import '../../models/collaborator_model.dart';

class MessageScreen extends StatefulWidget {
  final Collaborator? event;

  const MessageScreen({super.key, this.event});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Saya',
      'message': 'Halo, saya tertarik untuk bergabung dengan kegiatan ini.',
      'time': '10:00',
      'isMe': true,
    },
    {
      'sender': 'Penyelenggara',
      'message': 'Halo, terima kasih atas ketertarikannya. Silakan bergabung.',
      'time': '10:05',
      'isMe': false,
    },
    {
      'sender': 'Saya',
      'message': 'Baik, saya akan bergabung. Ada yang perlu saya siapkan?',
      'time': '10:10',
      'isMe': true,
    },
    {
      'sender': 'Penyelenggara',
      'message': 'Ya, silakan bawa peralatan kebersihan dan air minum.',
      'time': '10:15',
      'isMe': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'Saya',
          'message': _messageController.text,
          'time': DateTime.now().toString().split(' ')[1].substring(0, 5),
          'isMe': true,
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.event != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event!.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${widget.event!.participants.length} Peserta',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
                : const Text('Pesan'),
        backgroundColor: Colors.green[400],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[400]!, Colors.green[50]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment:
                        message['isMe']
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            message['isMe'] ? Colors.green[400] : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['sender'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  message['isMe']
                                      ? Colors.white
                                      : Colors.green[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['message'],
                            style: TextStyle(
                              color:
                                  message['isMe']
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  message['isMe']
                                      ? Colors.white70
                                      : Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.green[50],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
