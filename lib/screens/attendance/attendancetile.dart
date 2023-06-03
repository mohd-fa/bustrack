import 'package:bustrack/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceTile extends StatefulWidget {
  final AsyncSnapshot attendanceSnap;
  final QueryDocumentSnapshot studentDoc;
  final bool isPickup;
  const AttendanceTile(
      {super.key,
      required this.attendanceSnap,
      required this.studentDoc,
      required this.isPickup});

  @override
  State<AttendanceTile> createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  final _db = DataBaseServices();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.black,
      trailing: (!widget.attendanceSnap.hasData ||
              !widget.attendanceSnap.data!
                  .containsKey(widget.isPickup ? 'pickup' : 'drop'))
          ? IconButton(
              color: Colors.green,
              icon: const Icon(Icons.check),
              onPressed: () {
                _db.updateAttendance(widget.studentDoc.id,
                    widget.attendanceSnap.hasData, widget.isPickup);
              },
            )
          : null,
      title: Text(
        widget.studentDoc['name'],
      ),
      subtitle: Text(
          '${widget.studentDoc['class']}-${widget.studentDoc['div']}',
          style: const TextStyle(color: Colors.black45)),
    );
  }
}
