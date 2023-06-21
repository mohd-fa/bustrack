import 'package:bustrack/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageSent extends StatefulWidget {
  const MessageSent({super.key});

  @override
  State<MessageSent> createState() => _MessageSentState();
}

class _MessageSentState extends State<MessageSent> {
  final db = DataBaseServices();
  final TextEditingController _messagecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Message'),
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
                stream: db.getMessage(),
                builder: (context, snapshot) {
                  List messages = [];
                  if (snapshot.hasData) {
                    messages = snapshot.data!.docs;
                  }
                  return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.all(0),
                                  child: ListTile(
                                      minVerticalPadding: 16,
                                      tileColor: Colors.blueGrey[100],
                                      title: Text(messages[index]['message']),
                                      subtitle: Text(
                                        DateFormat('dd-MM-yyyy hh:mm a').format(
                                            (messages[index]['timestamp']
                                                    as Timestamp)
                                                .toDate()),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                })),
        const Divider(
          color: Colors.black12,
          thickness: 1,
          height: 1,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: _messagecontroller,
                  textInputAction: TextInputAction.none,
                  decoration: const InputDecoration(
                      hintText: "message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              IconButton(
                splashRadius: 0.1,
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  db.uploadMessage(_messagecontroller.text);
                  _messagecontroller.clear();
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
