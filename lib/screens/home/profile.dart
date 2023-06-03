import 'package:bustrack/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(children: [
            const CircleAvatar(radius: 30, child: Icon(Icons.person_3_rounded)),
            const SizedBox(
              width: 20,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.name!.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23)),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${user.clas!.toUpperCase()}-${user.div!.toUpperCase()}',
                style: const TextStyle(fontSize: 18),
              ),
            ])
          ]),
        ));
  }
}
