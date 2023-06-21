import 'package:bustrack/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageReceive extends StatefulWidget {
  const MessageReceive({super.key});

  @override
  State<MessageReceive> createState() => _MessageReceiveState();
}

class _MessageReceiveState extends State<MessageReceive> {
  final db = DataBaseServices();
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
      ]),
    );
  }
}
