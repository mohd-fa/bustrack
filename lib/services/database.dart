import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseServices {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference adminLoc = 
      FirebaseFirestore.instance.collection('adminLoc');
  

  Future updateUser(String uid, String admin) async {
    return await user.doc(uid).set({'type': 0,'admin':admin});
  }

  Future getUser(String uid) async {
    DocumentSnapshot documentSnapshot = await user.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  Future updateLoc(String uid,double? latitude, double? longitude) async{
    return await adminLoc.doc(uid).set({'latitude': latitude,
        'longitude': longitude,
        'timestamp': Timestamp.now()
        },SetOptions(merge: true));
  }

  Stream get getMap => adminLoc.snapshots();
}
