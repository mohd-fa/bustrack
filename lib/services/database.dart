import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bustrack/services/location.dart';

class DataBaseServices {
  final location = LocationService();

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
    final locdata = await location.getLocation;
    if (docexists) {
      user
          .doc(id)
          .collection('attendance')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .update({
        time: DateFormat('hh:mm').format(DateTime.now()),
        '${time}latitude': locdata.latitude,
        '${time}longitude': locdata.longitude
      });
    } else {
      user
          .doc(id)
          .collection('attendance')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .set({
        time: DateFormat('hh:mm').format(DateTime.now()),
        '${time}latitude': locdata.latitude,
        '${time}longitude': locdata.longitude
      });
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

  Stream<Map> getrAttendance(id, DateTime date) async* {
    late DocumentSnapshot doc;
    await for (doc in user
        .doc(id)
        .collection('attendance')
        .doc(DateFormat('yyyy-MM-dd').format(date))
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

  Future uploadMessage(String message) async {
    return await FirebaseFirestore.instance.collection('message').doc().set(
      {'message': message, 'timestamp': Timestamp.now()},
    );
  }

  Stream<QuerySnapshot> getMessage() {
    return FirebaseFirestore.instance
        .collection('message')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream get getMap => adminLoc.snapshots();
}
