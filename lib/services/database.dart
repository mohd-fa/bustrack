import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DataBaseServices {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference adminLoc =
      FirebaseFirestore.instance.collection('adminLoc');

  updateUser(
      String uid, String name, String clas, String div, String admin) async {
    return await user.doc(uid).set(
        {'type': 0, 'name': name, 'class': clas, 'div': div, 'admin': admin});
  }

  Future getUser(String uid) async {
    DocumentSnapshot documentSnapshot = await user.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  Stream<QuerySnapshot> get getStudents =>
      user.where('type', isEqualTo: 0).snapshots();

  updateAttendance(id, docexists, isPickup) async {
    String time = isPickup ? 'pickup' : 'drop';
    if (docexists) {
      user
          .doc(id)
          .collection('attendance')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .update({time: DateFormat('hh:mm').format(DateTime.now())});
    } else {
      user
          .doc(id)
          .collection('attendance')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .set({time: DateFormat('hh:mm').format(DateTime.now())});
    }
  }

  Stream<Map> getAttendance(id) async* {
    late DocumentSnapshot doc;
    await for (doc in user
        .doc(id)
        .collection('attendance')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .snapshots()) {
      yield doc.data() as Map;
    }
  }

  Future updateLoc(String uid, double? latitude, double? longitude) async {
    return await adminLoc.doc(uid).set({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.now()
    }, SetOptions(merge: true));
  }

  Stream get getMap => adminLoc.snapshots();
}
